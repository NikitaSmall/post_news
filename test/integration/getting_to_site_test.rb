require 'test_helper'
# rails generate integration_test getting_to_site

class GettingToSiteTest < ActionDispatch::IntegrationTest 
  include Capybara::DSL

  setup do
    # Capybara.default_driver = :selenium
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default
    Capybara.app_host = 'http://apex-news.herokuapp.com'
 	 page.driver.browser.manage.delete_all_cookies
  end

	
  test 'should_shows_city_in_russian_language' do
    visit '/'  
    assert page.has_content? 'APEX NEWS'
    assert page.has_content? 'Одесса'
	end

  test 'should_shows_error_message_on_login_page' do
  	 #visit '/users/sign_out'
  	 #page.driver.browser.manage.delete_all_cookies
	 visit '/users/sign_in'
	 fill_in('user[email]', :with => '')
	 fill_in('user[password]', :with => '')
	 click_on('Войти')
    assert page.has_content? 'или пароль' #error message
  end  
  
  	test 'user_should_can_login_to_adminpage' do
	 visit '/posts'
    assert page.has_content? 'необходимо войти'	 
	 visit '/users/sign_in'
	 fill_in('user[email]', :with => 'autor1@mail.ru')
	 fill_in('user[password]', :with => '12345678')
	 click_on('Войти')	
    assert page.has_content? 'Вход в систему выполнен' #logining is completed
    #user must see this sections:
    assert page.has_content? 'Мои новости'
    assert page.has_content? 'Список пользователей'
    assert page.has_content? 'Управление рекламой'
    assert page.has_content? 'Новый пост'
    assert page.has_content? 'Настройки'
    assert page.has_content? 'Личный профиль'
  end  
  
  
end
