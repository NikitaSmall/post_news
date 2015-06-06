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


class WriteNewPostTest < ActionDispatch::IntegrationTest
include Capybara::DSL

  setup do
    # Capybara.default_driver = :selenium
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default
    #Capybara.register_driver :mechanize do |app| #silent mode line1
    #Capybara::Mechanize::Driver.new(app) #silent mode line2
    Capybara.app_host = 'http://apex-news.herokuapp.com'
    page.driver.browser.manage.delete_all_cookies  
    page.driver.browser.manage.window.maximize
  end


	
  test 'autor_should_be_able_write_post' do
  
    users_mail = 'autor1@mail.ru'
    users_password = '12345678'  
    variable = ' ' + Time.now.strftime("%s")
    post_title = 'Test title'+variable
    post_content = users_mail + ': This is my message!'
    post_tag1 = 'test tag, '
    post_tag2 = 'test tag 2'
    post_attach = '/home/vlad/Templates/capybara_pic/'+rand(1...26).to_s+'.jpg'
  
    visit '/users/sign_in'
    fill_in('user[email]', :with => users_mail)
    fill_in('user[password]', :with => users_password)
    click_on('Войти')	#Вход в систему выполнен.
    assert page.has_content? 'Вход в систему выполнен' 
  
    visit '/admin'
    click_on('Новый пост') 	
    assert page.has_content?('Новая статья') 
    click_on('Опубликовать')
    assert page.has_content?('необходимо заполнить', count:3)
  
	  fill_in('post[title]', :with => post_title)
	  fill_in_ckeditor 'content', :with => post_content
	  fill_in('post[tag_list]', :with => post_tag1+post_tag2)
	  attach_file('post[photo]', post_attach)
	  #autor cant feature posts

	  click_on('Опубликовать') 
    assert page.has_content?('успешно')
    assert page.has_content?(post_title)
    assert page.has_content?(post_content)
    assert page.has_content?(post_tag2)  

 
 	  click_on('Читать на сайте')  
 	  assert page.has_content?(post_title)
    assert page.has_content?(post_content)
    #assert page.has_content?('test tag 2'.upcase) 
  
    visit '/posts/new'	
    fill_in('post[title]', :with => post_title)
    click_on('Опубликовать')
    assert page.has_content?('уникальным')
  
    #visit '/admin'
	  click_on('Личный кабинет') 
    assert page.has_content?('Автор')
  
    click_on('Список пользователей') 
    assert page.has_content?('Только администратор может')
  
    click_on('Настройки') 
    assert page.has_content?('нет прав')
  
    click_on('Управление рекламой')
    assert page.has_content?('нет прав')
   
  end
  
  test 'redactor_can_create_new_post_and_new_ad' do

    users_mail = 'redactor1@mail.ru'
    users_password = '12345678'  
    variable = ' ' + Time.now.strftime("%s")
    post_title = 'Test title'+variable
    post_content = users_mail + ': This is my message!'
    post_tag1 = 'test tag, '
    post_tag2 = 'test tag 2'
    post_attach = '/home/vlad/Templates/capybara_pic/'+rand(1...26).to_s+'.jpg'
  
    visit '/users/sign_in'
    fill_in('user[email]', :with => users_mail)
    fill_in('user[password]', :with => users_password)
    click_on('Войти')	#Вход в систему выполнен.
    assert page.has_content? 'Вход в систему выполнен' 
  
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
  
    visit '/'
    assert page.has_content?(post_title)
    page.save_screenshot 'test/integration/screens/featured_'+variable+'_post.png'
    
    #deleting    
    visit '/posts' 
    accept_alert do
      find(:xpath, "//html/body/div/div/div/table/tbody/tr[1]/td[9]/a/span").click
    end

    visit '/users_admin'
    assert page.has_content?('Только администратор может')

    visit '/users/show/51'
    assert page.has_content?('Редактор')
    #must be new post
  
    visit '/options'	
    assert page.has_content?('нет прав')
  
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

  end
  
  test 'corrector_can_correcting_only' do

    users_mail = 'corrector1@mail.ru'
    users_password = '12345678'  
  
    visit '/users/sign_in'
    fill_in('user[email]', :with => users_mail)
    fill_in('user[password]', :with => users_password)
    click_on('Войти')	#Вход в систему выполнен.
    assert page.has_content? 'Вход в систему выполнен' 
  
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

  end

end
