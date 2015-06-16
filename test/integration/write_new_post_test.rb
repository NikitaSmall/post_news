require 'test_helper'
# rake test:integration TEST=test/integration/write_new_post_test.rb

#this is method for work with wysiwyg redactor
def fill_in_ckeditor(locator, opts)
  content = opts.fetch(:with).to_json
  page.execute_script <<-SCRIPT
  CKEDITOR.instances['#{locator}'].setData(#{content});
  $('textarea##{locator}').text(#{content});
  SCRIPT
end

def login_as(nickname)
    users_mail = nickname + '1@mail.ru'
    users_password = '12345678'  
    visit '/users/sign_in'
    fill_in('user[email]', :with => users_mail)
    fill_in('user[password]', :with => users_password)
    click_on('Войти')	#Вход в систему выполнен.
    assert page.has_content? 'Вход в систему выполнен' 
end


class WriteNewPostTest < ActionDispatch::IntegrationTest
include Capybara::DSL

  setup do
    # Capybara.default_driver = :selenium
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default
    Capybara.app_host = 'http://apex-news.herokuapp.com'
    page.driver.browser.manage.delete_all_cookies  
    page.driver.browser.manage.window.maximize
  end


  test 'autors_rights' do
    #autor_can_write_a_new_post
    users_mail = 'autor1@mail.ru'
    users_password = '12345678'  
    variable = ' ' + Time.now.strftime("%s")
    post_title = 'Test title'+variable
    post_content = users_mail + ': This is my message!'
    post_tag1 = 'test tag, '
    post_tag2 = 'test tag 2'
    post_attach = '/home/vlad/Templates/capybara_pic/'+rand(1...26).to_s+'.jpg'
    post_attach2 = '/home/vlad/Templates/capybara_pic/'+rand(1...26).to_s+'.jpg'
      
    #login as autor
    visit '/users/sign_in'
    fill_in('user[email]', :with => users_mail)
    fill_in('user[password]', :with => users_password)
    click_on('Войти')	#Вход в систему выполнен.
    assert page.has_content? 'Вход в систему выполнен' 
  
    #ajax errors on the creating-post page
    visit '/admin'
    click_on('Новый пост') 	
    assert page.has_content?('Новая статья') 
    click_on('Опубликовать')
    assert page.has_content?('необходимо заполнить', count:3) #ERROR NOW
  
    #filling fields
	  fill_in('post[title]', :with => post_title)
	  fill_in_ckeditor 'content', :with => post_content
	  fill_in('post[tag_list]', :with => post_tag1+post_tag2)
	  attach_file('post[photo]', post_attach)
	  assert page.has_no_content?(:xpath, "//form/div[@class='form-group'][4]/input[@id='post_main']")  
	  #autor cant feature posts

    #sucsessfull creating of new post
	  click_on('Опубликовать') 
    assert page.has_content?('успешно')
    assert page.has_content?(post_title)
    assert page.has_content?(post_content)
    assert page.has_content?(post_tag2)  

    #can see it on the front part of website
 	  click_on('Читать на сайте')  
 	  assert page.has_content?(post_title)
    assert page.has_content?(post_content)
    #assert page.has_content?('test tag 2'.upcase) 
    assert find_link(post_tag2)
      
    #checking for non-repeat title
    visit '/posts/new'	
    fill_in('post[title]', :with => post_title)
    click_on('Опубликовать')
    assert page.has_content?('уникальным') #ERROR NOW

    #autor_should_be_able_to_edit_only_his_post and_cant_delete posts
    click_on('Список новостей')
    not_my_post = 0
    
    for k in 1..7
      if find(:xpath, "//table/tbody/tr[#{k}]/td[4]").text == 'autor' 
        assert page.has_xpath?("//table/tbody/tr[#{k}]/td[8]/a/span") #edit_button
        else
          assert page.has_no_xpath?("//table/tbody/tr[#{k}]/td[8]/a/span") #invisible edit_button
          not_my_post = k
      end
      assert page.has_no_xpath?("//table/tbody/tr[#{k}]/td[9]/a/span")  #invisible delete_button
    end

    if not_my_post != 0
      find(:xpath, "//table/tbody/tr[#{not_my_post}]/td[2]/a").click  
      click_on('Редактировать') 
      assert page.has_content?('не можешь')  
    end 
    
    #autor can edit his posts
    visit '/posts/'    
    find(:xpath, "//table/tbody/tr[1]/td[8]/a/span").click
	  fill_in('post[title]', :with => post_title+' re title')
	  fill_in_ckeditor 'content', :with => post_content + ' re content'
	  fill_in('post[tag_list]', :with => post_tag1+post_tag2+', retag')
	  attach_file('post[photo]', post_attach2)
	  click_on('Опубликовать')   
    assert page.has_content?('успешно') 


    #post may be with other main news
    visit '/posts/'
    click_on('Новости на главной')
        
    #redactor can change position of the post
    buffer_name = find(:xpath, "//table/tbody/tr[1]/td[2]").text
    
    find(:xpath, "//table/tbody/tr[1]/td[1]/a[2]").click      
    if find(:xpath, "//table/tbody/tr[2]/td[2]").text == buffer_name 
      assert false
    else 
      assert true
    end
    
        
    
    #all pages in admin-panel
    click_on('Мои новости')
    assert page.has_content?(post_title+' re title')
    
	  click_on('Личный кабинет')
    assert page.has_content?(post_title+' re title')	   
    assert page.has_content?('Автор')
    attach_file('user[avatar]', post_attach)
    click_on('Сменить аватар') 
  
    click_on('Список пользователей') 
    assert page.has_content?('Только администратор может')

    click_on('Управление рекламой')
    assert page.has_content?('нет прав')
  
    click_on('Настройки') 
    assert page.has_content?('нет прав')
    
    #logout
    click_on('Выйти')
    assert page.has_content?('Выход из системы выполнен')
    
    #login as admin
    users_mail = 'administrator1@mail.ru'
    users_password = '12345678' 
    visit '/users/sign_in'    
    fill_in('user[email]', :with => users_mail)
    fill_in('user[password]', :with => users_password)
    click_on('Войти')	
    assert page.has_content? 'Вход в систему выполнен'   
    
    #deleting
    visit '/posts' 
    accept_alert do
      find(:xpath, "//table/tbody/tr[1]/td[9]/a/span").click
    end  	  

  end


  test 'redactors_rights' do
    #redactor_can_create_new_post_and_new_ad
    users_mail = 'redactor1@mail.ru'
    number_of_user = '51'
    autor_mail = 'autor1@mail.ru'
    users_password = '12345678'  
    variable = ' ' + Time.now.strftime("%s")
    post_title = 'Test title'+variable
    post_content = users_mail + ': This is my message!'
    post_content2 = autor_mail + ': This is my message for redactor!'
    post_tag1 = 'test tag, '
    post_tag2 = 'test tag 2'
    post_attach = '/home/vlad/Templates/capybara_pic/'+rand(1...26).to_s+'.jpg'
    post_attach2 = '/home/vlad/Templates/capybara_pic/'+rand(1...26).to_s+'.jpg'
      
    #login as autor
    visit '/users/sign_in'
    fill_in('user[email]', :with => autor_mail)
    fill_in('user[password]', :with => users_password)
    click_on('Войти')	#Вход в систему выполнен.
    assert page.has_content? 'Вход в систему выполнен'      
    
    #write post
    visit '/posts/new'
    fill_in('post[title]', :with => post_title)
    fill_in_ckeditor 'content', :with => post_content2
    fill_in('post[tag_list]', :with => post_tag1+post_tag2)
    attach_file('post[photo]', post_attach)
    click_on('Опубликовать')
    
    #logout
    click_on('Выйти')
    assert page.has_content?('Выход из системы выполнен')
   
    #login as redactor
    visit '/users/sign_in'
    fill_in('user[email]', :with => users_mail)
    fill_in('user[password]', :with => users_password)
    click_on('Войти')	#Вход в систему выполнен.
    assert page.has_content? 'Вход в систему выполнен' 

    #edit autors post
    visit '/posts'
    find(:xpath, "//table/tbody/tr[1]/td[8]/a/span").click
    fill_in('post[title]', :with => post_title+' +redactor')
    fill_in_ckeditor 'content', :with => post_content+' +redactor'
    fill_in('post[tag_list]', :with => post_tag1+post_tag2+', redactors tag')
    attach_file('post[photo]', post_attach)
    check('Новость отображается на главной')
    check('Новость выделена на главной')
    click_on('Опубликовать')
    
    assert page.has_content?('успешно')
    assert page.has_content?(post_title+' +redactor')
    assert page.has_content?(post_content+' +redactor')
    assert page.has_content?(post_tag2)  

    #deleting post from autor
    visit '/posts' 
    accept_alert do
      find(:xpath, "//table/tbody/tr[1]/td[9]/a/span").click
    end 
    visit '/posts' 
    assert page.has_no_content?(post_title+' +redactor')

    #create post by redactor
    visit '/posts/new'
    fill_in('post[title]', :with => post_title)
    fill_in_ckeditor 'content', :with => post_content
    fill_in('post[tag_list]', :with => post_tag1+post_tag2)
    attach_file('post[photo]', post_attach)
    check('Новость отображается на главной')
    check('Новость выделена на главной')

    click_on('Опубликовать')
    assert page.has_content?('успешно')
    assert page.has_content?(post_title)
    assert page.has_content?(post_content)
    assert page.has_content?(post_tag2)  
  
    #post may be with other main news
    visit '/posts/'
    click_on('Новости на главной')
    assert page.has_content?(post_title) 
    
    #redactor can change position of the post
    find(:xpath, "//table/tbody/tr[1]/td[1]/a[2]").click      
    if find(:xpath, "//table/tbody/tr[2]/td[2]").text == post_title 
      assert true
    else 
      assert false
    end
    
    find(:xpath, "//table/tbody/tr[2]/td[1]/a[1]").click      #back
    if find(:xpath, "//table/tbody/tr[1]/td[2]").text == post_title 
      assert true
    else 
      assert false
    end
  
    #making screenshot from main page
    visit '/'
    assert page.has_content?(post_title)
    page.save_screenshot 'test/integration/screens/featured_'+variable+'_post.png'
    
    #deleting    
    visit '/posts/' 
    dismiss_confirm do
      find(:xpath, "//table/tbody/tr[1]/td[9]/a/span").click
    end    
    assert page.has_content?(post_title)    
    accept_alert do
      find(:xpath, "//table/tbody/tr[1]/td[9]/a/span").click
    end

    #other sections
    visit "/users/show/#{number_of_user}"
    assert page.has_content?('Редактор')
 
    visit '/users_admin'
    assert page.has_content?('Только администратор может')

    
    visit '/advertisements'
    assert page.has_content?('Реклама')
    visit '/advertisements/new'
    assert page.has_content?('Новая')
    click_on('Опубликовать')
    assert page.has_content?('необходимо заполнить', count:4)
  
    fill_in('advertisement[title]', :with => post_title)
    fill_in('advertisement[link]', :with => Capybara.app_host)
    fill_in_ckeditor 'content', :with => post_content
    attach_file('advertisement[photo]', post_attach)
    
    click_on('Опубликовать')
    #assert page.has_content?('Редактировать')
    assert page.has_content?(post_title)
    assert page.has_content?(post_content)
    assert page.has_content?(Capybara.app_host)  

    #delete advertise
    visit '/advertisements'
    number_of_del_ad = 1

    for k in 1..10         #shitcode_from_hell TODO: it should be better
      number_of_del_ad = k 
      if find(:xpath, "//table/tbody/tr[#{number_of_del_ad}]/td[1]/a").text == post_title
        break
      end
       
    end 
    
    
    accept_alert do
      find(:xpath, "//table/tbody/tr[#{number_of_del_ad}]/td[7]/a").click 
    end    
    visit '/advertisements' 
    assert page.has_no_content?(post_title)
           
    visit '/options'	
    assert page.has_content?('нет прав')
    
  end

 
  test 'correctors_rights' do
    #corrector_can_correcting_only
    users_mail = 'corrector1@mail.ru'
    users_password = '12345678'  
    autor_mail = 'autor1@mail.ru'
    variable = ' ' + Time.now.strftime("%s")
    post_title = 'Test title'+variable
    post_content = users_mail + ': This is my message!'
    post_tag1 = 'test tag, '
    post_tag2 = 'test tag 2'
    post_attach = '/home/vlad/Templates/capybara_pic/'+rand(1...26).to_s+'.jpg'
    
            
    #login as autor
    visit '/users/sign_in'
    fill_in('user[email]', :with => autor_mail)
    fill_in('user[password]', :with => users_password)
    click_on('Войти')	#Вход в систему выполнен.
    assert page.has_content? 'Вход в систему выполнен'      
    
    #write post
    visit '/posts/new'
    fill_in('post[title]', :with => post_title)
    fill_in_ckeditor 'content', :with => post_content
    fill_in('post[tag_list]', :with => post_tag1+post_tag2)
    attach_file('post[photo]', post_attach)
    click_on('Опубликовать')
    
    #logout
    click_on('Выйти')
    assert page.has_content?('Выход из системы выполнен')
  
    #login as corrector
    visit '/users/sign_in'
    fill_in('user[email]', :with => users_mail)
    fill_in('user[password]', :with => users_password)
    click_on('Войти')	#Вход в систему выполнен.
    assert page.has_content? 'Вход в систему выполнен' 
  
    #edit autors post
    visit '/posts'
    find(:xpath, "//table/tbody/tr[1]/td[8]/a/span").click
    fill_in('post[title]', :with => post_title+' +corrector')
    fill_in_ckeditor 'content', :with => post_content+' +corrector'
    fill_in('post[tag_list]', :with => post_tag1+post_tag2+', correctors tag')
    attach_file('post[photo]', post_attach)
    assert page.has_no_content?(:xpath, "//form/div[@class='form-group'][4]/input[@id='post_main']")  
    click_on('Опубликовать')
    
    assert page.has_content?('успешно')
    assert page.has_content?(post_title+' +corrector')
    assert page.has_content?(post_content+' +corrector')
    assert page.has_content?(post_tag2)  

    #deleting of post
    visit '/posts' 
    assert page.has_no_content?(:xpath, "//table/tbody/tr[1]/td[9]/a/span")

    #corrector should be able to change position of the post
    visit '/posts/'
    click_on('Новости на главной')
    buffer_name = find(:xpath, "//table/tbody/tr[1]/td[2]").text
    #change position
    find(:xpath, "//table/tbody/tr[1]/td[1]/a[2]").click      
    if find(:xpath, "//table/tbody/tr[2]/td[2]").text == buffer_name 
      assert true
    else 
      assert false
    end
    #change to default
    find(:xpath, "//table/tbody/tr[2]/td[1]/a[1]").click  
    if find(:xpath, "//table/tbody/tr[1]/td[2]").text == buffer_name 
      assert true
    else 
      assert false
    end 
  
    #other pages
    visit '/admin'
    click_on('Личный кабинет') 
    assert page.has_content?('Корректор')

    click_on('Новый пост') 
    assert page.has_content?('не можешь')  
  
    click_on('Мои новости')
    assert page.has_content?('не можете')

    click_on('Список пользователей') 
    assert page.has_content?('Только администратор может')

    click_on('Настройки') 
    assert page.has_content?('нет прав')
  
    click_on('Управление рекламой')
    assert page.has_content?('нет прав')
  
    click_on('Выйти')
    assert page.has_content?('Выход из системы выполнен')

    #TODO: login as admin and delete post

  end


  test 'admins_rights' do
  
    users_mail = 'administrator1@mail.ru'
    autor_mail = 'autor1@mail.ru'
    users_password = '12345678'  
    variable = ' ' + Time.now.strftime("%s")
    post_title = 'Test title'+variable
    post_content = users_mail + ': This is my message!'
    post_content2 = autor_mail + ': This is my message for admin!'
    post_tag1 = 'test tag, '
    post_tag2 = 'test tag 2'
    post_attach = '/home/vlad/Templates/capybara_pic/'+rand(1...26).to_s+'.jpg'
    post_attach2 = '/home/vlad/Templates/capybara_pic/'+rand(1...26).to_s+'.jpg'
      
=begin      
    #login as autor
    visit '/users/sign_in'
    fill_in('user[email]', :with => autor_mail)
    fill_in('user[password]', :with => users_password)
    click_on('Войти')	#Вход в систему выполнен.
    assert page.has_content? 'Вход в систему выполнен'      
=end

    login_as 'autor'
        
    #write post
    visit '/posts/new'
    fill_in('post[title]', :with => post_title)
    fill_in_ckeditor 'content', :with => post_content2
    fill_in('post[tag_list]', :with => post_tag1+post_tag2)
    attach_file('post[photo]', post_attach)
    click_on('Опубликовать')
    
    #logout
    click_on('Выйти')
    assert page.has_content?('Выход из системы выполнен')
   
    #login as admin
    visit '/users/sign_in'
    fill_in('user[email]', :with => users_mail)
    fill_in('user[password]', :with => users_password)
    click_on('Войти')	#Вход в систему выполнен.
    assert page.has_content? 'Вход в систему выполнен' 

    #edit autors post
    visit '/posts'
    find(:xpath, "//table/tbody/tr[1]/td[8]/a/span").click
    fill_in('post[title]', :with => post_title+' +admin')
    fill_in_ckeditor 'content', :with => post_content+' +admin'
    fill_in('post[tag_list]', :with => post_tag1+post_tag2+', admins tag')
    attach_file('post[photo]', post_attach)
    check('Новость отображается на главной')
    check('Новость выделена на главной')
    click_on('Опубликовать')
    
    assert page.has_content?('успешно')
    assert page.has_content?(post_title+' +admin')
    assert page.has_content?(post_content+' +admin')
    assert page.has_content?(post_tag2)  

    #deleting post from autor
    visit '/posts' 
    accept_alert do
      find(:xpath, "//table/tbody/tr[1]/td[9]/a/span").click
    end 
    visit '/posts' 
    assert page.has_no_content?(post_title+' +admin')
  
    #create post by admin
    visit '/posts/new'
    fill_in('post[title]', :with => post_title)
    fill_in_ckeditor 'content', :with => post_content
    fill_in('post[tag_list]', :with => post_tag1+post_tag2)
    attach_file('post[photo]', post_attach)
    check('Новость отображается на главной')
    check('Новость выделена на главной')

    click_on('Опубликовать')
    assert page.has_content?('успешно')
    assert page.has_content?(post_title)
    assert page.has_content?(post_content)
    assert page.has_content?(post_tag2)  
  
    #post may be with other main news
    visit '/posts/'
    click_on('Новости на главной')
    assert page.has_content?(post_title) 
    
    #redactor can change position of the post
    find(:xpath, "//table/tbody/tr[1]/td[1]/a[2]").click      
    if find(:xpath, "//table/tbody/tr[2]/td[2]").text == post_title 
      assert true
    else 
      assert false
    end
    
    find(:xpath, "//table/tbody/tr[2]/td[1]/a[1]").click      #back
    if find(:xpath, "//table/tbody/tr[1]/td[2]").text == post_title 
      assert true
    else 
      assert false
    end
  
    #making screenshot from main page
    visit '/'
    assert page.has_content?(post_title)
    page.save_screenshot 'test/integration/screens/featured_'+variable+'_post.png'
    
    #deleting    
    visit '/posts/' 
    assert page.has_content?(post_title)    
    accept_alert do
      find(:xpath, "//table/tbody/tr[1]/td[9]/a/span").click
    end

    #other sections
    click_on('Личный кабинет') 
    assert page.has_content?('Администратор')
 
    click_on('Список пользователей') 
    assert page.has_content?('В администратора!')

    visit '/advertisements'
    assert page.has_content?('Реклама')
    click_on('Новое рекламное объявление') 
    assert page.has_content?('Новая')
  
    fill_in('advertisement[title]', :with => post_title)
    fill_in('advertisement[link]', :with => Capybara.app_host)
    fill_in_ckeditor 'content', :with => post_content
    attach_file('advertisement[photo]', post_attach)
    check('Сделать рекламу активной')
    
    click_on('Опубликовать')
    assert page.has_content?(post_title)
    assert page.has_content?(post_content)
    assert page.has_content?(Capybara.app_host)  

    #delete advertise
    visit '/advertisements'
    number_of_del_ad = 1

    for k in 1..10         #shitcode_from_hell TODO: it should be better
      number_of_del_ad = k 
      if find(:xpath, "//table/tbody/tr[#{number_of_del_ad}]/td[1]/a").text == post_title
        break
      end
       
    end 
    
    
    accept_alert do
      find(:xpath, "//table/tbody/tr[#{number_of_del_ad}]/td[7]/a").click 
    end    
    visit '/advertisements' 
    assert page.has_no_content?(post_title)
    
    visit '/options'	
    assert page.has_content?('Настройки', count:4)
  end
end
