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
    #Capybara.register_driver :mechanize do |app| #silent mode
    #Capybara::Mechanize::Driver.new(app)
    Capybara.app_host = 'http://apex-news.herokuapp.com'
    page.driver.browser.manage.delete_all_cookies   
  end


	
  test 'autor_should_can_write_post' do
  
  	 users_mail = 'autor1@mail.ru'
  	 users_password = '12345678'  
  	 variable = ' ' + Time.now.strftime("%s")
  	 post_title = 'Test title'+variable
	 post_content = users_mail + ': This is my message!'
	 post_tag1 = 'test tag, '
	 post_tag2 = 'test tag 2'
  	 
    visit '/users/sign_in'
	 fill_in('user[email]', :with => users_mail)
	 fill_in('user[password]', :with => users_password)
	 click_on('Войти')	#Вход в систему выполнен.
    assert page.has_content? 'Вход в систему выполнен' 
  
	 visit '/posts/new'	 	 
	 click_on('Опубликовать')	#Вход в систему выполнен.
    assert page.has_content?('необходимо заполнить', count:3)
    
	 fill_in('post[title]', :with => post_title)
	 fill_in_ckeditor 'content', :with => post_content
	 fill_in('post[tag_list]', :with => post_tag1+post_tag2)
	 attach_file('post[photo]', '/home/vlad/screen_0.png')
	 
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
    	    
  end
  
  
end
