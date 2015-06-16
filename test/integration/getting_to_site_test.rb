require 'test_helper'
# rails generate integration_test getting_to_site

class GettingToSiteTest < ActionDispatch::IntegrationTest 
  include Capybara::DSL

  setup do
    #Capybara.default_driver = :selenium
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default
    Capybara.app_host = 'http://apex-news.herokuapp.com'
    page.driver.browser.manage.delete_all_cookies
    page.driver.browser.manage.window.maximize
  end

	
  test 'should_shows_city_in_russian_language' do
    visit '/'  
    assert page.has_content? 'apex news'.upcase 
    assert page.has_content? 'Одесса'
    find(:xpath, "//a[@class='read-more-btn']")
    #assert page.has_content? 'Читать полностью' #.upcase 
  end

  test 'autorization_should_shows_error_messages_on_login_page' do

    visit '/admin'
    assert page.has_content? 'или зарегистрироваться' #error message
    
    visit '/users/sign_in'
    assert page.has_content? 'Электронная почта'
    assert page.has_content? 'Пароль'
    fill_in('user[email]', :with => '')
    fill_in('user[password]', :with => '')
    find(:xpath, "//form/div/input[@class='btn btn-default']").click
    assert page.has_content? 'или пароль' #error message
  end  
  
  test 'user_should_can_login_to_adminpage' do

    users_mail = 'administrator1@mail.ru'
    users_password = '12345678'  	
  	
    visit '/posts' #redirect and error
    assert page.has_content? 'необходимо войти'  
  
    fill_in('user[email]', :with => users_mail)
    fill_in('user[password]', :with => users_password)
    click_on('Войти')	
    assert page.has_content? 'Вход в систему выполнен' #logining is completed
  
    #user must see this sections:
    assert page.has_content? 'Мои новости'
    assert page.has_content? 'Список пользователей'
    assert page.has_content? 'Управление рекламой'
    assert page.has_content? 'Новый пост'
    assert page.has_content? 'Настройки'
    assert page.has_content? 'Личный кабинет'
  end  
  
  
end
