require 'test_helper'

#this is method for work with wysiwyg redactor
def fill_in_ckeditor(locator, opts)
  content = opts.fetch(:with).to_json
  page.execute_script <<-SCRIPT
  CKEDITOR.instances['#{locator}'].setData(#{content});
  $('textarea##{locator}').text(#{content});
  SCRIPT
end

class TagsTest < ActionDispatch::IntegrationTest
 include Capybara::DSL

  setup do
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default
    Capybara.app_host = 'http://apex-news.herokuapp.com'
    page.driver.browser.manage.delete_all_cookies
    page.driver.browser.manage.window.maximize
  end
  
    test 'can_see_tags' do
    
    #setup
    users_mail = 'administrator1@mail.ru'
    users_password = '12345678'  
    variable = ' ' + Time.now.strftime("%s")
    post_title = 'Test title'+variable
    post_content = users_mail + ': This is my message vs tags!'
    post_tag1 = 'test tag 1'
    post_tag2 = 'test tag 2'
    post_tag3 = 'test tag 3'
    post_tag4 = 'test tag 4'    
    post_attach = '/home/vlad/Templates/capybara_pic/'+rand(1...26).to_s+'.jpg'
    
    
    #login  
    visit '/users/sign_in'
    fill_in('user[email]', :with => users_mail)
    fill_in('user[password]', :with => users_password)
    click_on('Войти')	
    assert page.has_content? 'Вход в систему выполнен' 
   
    #create 3 posts
    visit '/admin'
    
    for k in 0..2 do
      click_on('Новый пост') 	
      assert page.has_content?('Новая статья')  
	    fill_in('post[title]', :with => post_title + ' ' + k.to_s)
	    fill_in_ckeditor 'content', :with => post_content
      check('Новость отображается на главной')	  
	    if k==0
	      fill_in('post[tag_list]', :with => post_tag1+', '+post_tag2+', '+post_tag3+', '+post_tag4)
	    else
	      fill_in('post[tag_list]', :with => post_tag2+', '+post_tag1+', '+post_tag3)	  
	    end
	  
	    attach_file('post[photo]', post_attach)    
      click_on('Опубликовать') 
    end

    #settings (tags and ads)
    click_on('Настройки') 
    saved_tag_num = find_by_id('tag_num').value
	  fill_in('tag_num', :with => '2')  
 	  #fill_in('fb-link', :with => saved_tag_num)  
    find(:xpath, "//input[@id='tag_butt']").click 
    saved_ads_num = find_by_id('ads_num').value       
 	  fill_in('ads_num', :with => '0')  
    find(:xpath, "//input[@id='ads_butt']").click   
    
            
    #logout
    click_on('Выйти')
    assert page.has_content?('Выход из системы выполнен')
    
    #find tag on page of material
    visit '/'
    find_link(post_title + ' 0').click 

    #find social sharing
    assert page.has_xpath?("//div[@class='social-share-button']") 
    social_window = window_opened_by do
      find(:xpath, "//div[@class='social-share-button']/a[1]").click  
    end
    
    within_window social_window do
    
    end
    
    #find discuss
    #assert page.has_xpath?("//div[@class='news-content col-md-8 comments-wrap']") 
    
    #find by tag
    find_link(post_tag1).click 
    assert page.has_content?(post_title + ' 0')   
    assert page.has_content?(post_title + ' 1') 
    assert page.has_content?(post_title + ' 2') 
    find_link(post_tag2).visible?  
    assert page.has_xpath?("//div[@class='tags text-center']/a[2]") 
    assert page.has_no_xpath?("//div[@class='tags text-center']/a[3]") 
    
    #find other tags
    find_link(post_tag2).click 
    assert page.has_content?(post_title + ' 0')   
    assert page.has_content?(post_title + ' 1') 
    assert page.has_content?(post_title + ' 2')      
    find_link(post_tag1).visible?  
    
    #login  
    visit '/users/sign_in'
    fill_in('user[email]', :with => users_mail)
    fill_in('user[password]', :with => users_password)
    click_on('Войти')	
    assert page.has_content? 'Вход в систему выполнен' 

    #delete posts     
    visit '/posts' 
    assert page.has_content?(post_title)  
    accept_alert do
      find(:xpath, "//table/tbody/tr[1]/td[9]/a/span").click
    end  
        
    visit '/posts' 
    assert page.has_content?(post_title)  
    accept_alert do
     find(:xpath, "//table/tbody/tr[1]/td[9]/a/span").click
    end  
        
    visit '/posts' 
    assert page.has_content?(post_title)  
    accept_alert do
     find(:xpath, "//table/tbody/tr[1]/td[9]/a/span").click
    end  
     
    #settings (tags and ads) #TODO: save old settings
    click_on('Настройки') 

 	  #fill_in('fb-link', :with => saved_tag_num)  
 	  fill_in('tag_num', :with => saved_tag_num)      
    find(:xpath, "//input[@id='tag_butt']").click 
 	  #fill_in('fb-link', :with => saved_ads_num)       
 	  fill_in('ads_num', :with => saved_ads_num)  
    find(:xpath, "//input[@id='ads_butt']").click   
   
    
    end
  
end