require 'test_helper'

class RegistrationTest < ActionDispatch::IntegrationTest
include Capybara::DSL

  setup do
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default
    Capybara.app_host = 'http://apex-news.herokuapp.com'
    page.driver.browser.manage.delete_all_cookies  
    page.driver.browser.manage.window.maximize
  end
  
  test 'try_to_create_an_account' do
    user_attach = '/home/vlad/Templates/capybara_pic/'+rand(1...26).to_s+'.jpg'
    
    visit '/users/sign_up'
    assert page.has_content? 'Регистрация' 
      
    assert page.has_content?('Имя')
    assert page.has_content?('почта')
    assert page.has_content?('ароль', count:2)
    assert page.has_content?('Аватар')
    #assert page.has_content?(:xpath, "//form[@id='register']/div[@class='form-group'][6]/div[@class='g-recaptcha']/div") 

    click_on('Зарегистрироваться')	    
    assert page.has_content?('необходимо', count:4)

    fill_in('user[username]', :with => 'ab')
    fill_in('user[email]', :with => 'ab@ab')    
    fill_in('user[password]', :with => '1234567')
    fill_in('user[password_confirmation]', :with => '123456')     
    
    find(:xpath, "//form/div/input[@class='btn btn-default']").click
    
    assert page.has_content?('не меньше 3')
    assert page.has_content?('корректный')
    assert page.has_content?('не меньше 8')
    assert page.has_content?('такое же')    
    
    fill_in('user[username]', :with => 'admin')
    fill_in('user[email]', :with => 'admin@mail.ru')  
    click_on('Зарегистрироваться')	    
    assert page.has_content?('уже используется', count:2)
    
    visit '/users/sign_in'
    assert page.has_content? 'Вход' 
    click_on('Зарегистрироваться')  

    long_username = ''
    max_username_length = 50
    for k in 1..max_username_length+1 do
    long_username = long_username+'i'
    end    
    
    fill_in('user[username]', :with => long_username) #'a23456789012345678901234567890123456789012345678901') 
    
    long_password = ''
    max_password_length = 128
    for k in 1..max_password_length+1 do
    long_password = long_password+'p'
    end 
         
    fill_in('user[password]', :with => long_password ) #'12345678901234567890123456789012345678901234567890'+
                                       #'12345678901234567890123456789012345678901234567890'+
                                       #'12345678901234567890123456789')
    click_on('Зарегистрироваться')	  
    assert page.has_content?('не больше ' + max_username_length.to_s)  
    assert page.has_content?('не больше ' + max_password_length.to_s)  
    
    fill_in('user[username]', :with => '1ab')
    find(:xpath, "//form/div/input[@class='btn btn-default']").click
    assert page.has_content?('только буква')
    
    fill_in('user[username]', :with => 'test_nikname'+rand(999...9999).to_s)
    fill_in('user[email]', :with => 'test_mail'+rand(999...9999).to_s+'@ya.ru')    
    fill_in('user[password]', :with => '12345678')
    fill_in('user[password_confirmation]', :with => '12345678')   
	  attach_file('user[avatar]', user_attach)  
    click_on('Зарегистрироваться') 
    
    assert page.has_content?('Пройдите капчу')
    
    #TODO: we should be smarter than captha
    
  end  
  
  
end
