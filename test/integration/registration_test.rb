require 'test_helper'

class RegistrationTest < ActionDispatch::IntegrationTest
include Capybara::DSL

  setup do
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default
    Capybara.app_host = 'http://apex-news.herokuapp.com'
    page.driver.browser.manage.delete_all_cookies  
    page.driver.browser.manage.window.maximize
  end
  
  test 'find_the_registration' do
  
    visit '/users/sign_up'
    assert page.has_content? 'Регистрация' 
      
    assert page.has_content?('Имя')
    assert page.has_content?('почта')
    assert page.has_content?('ароль', count:2)
    assert page.has_content?('Аватар')
    assert page.has_content?(:xpath, "//html/body/div/div/div/form/div/div[@class='g-recaptcha']") 

    click_on('Зарегистрироваться')	    
    assert page.has_content?('необходимо', count:2)

    fill_in('user[username]', :with => 'ab')
    fill_in('user[email]', :with => 'ab@ab')    
    fill_in('user[password]', :with => '1234567')
    fill_in('user[password_confirmation]', :with => '123456')     
    
    find(:xpath, "//html/body/div/div/div/form/div/input[@class='btn btn-default']").click
    
    assert page.has_content?('не меньше 3')
    assert page.has_content?('корректный')
    assert page.has_content?('не меньше 8')
    assert page.has_content?('такое же')    
  
  end  
  
  
end
