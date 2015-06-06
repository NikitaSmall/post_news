require 'test_helper'

#this is method for work with wysiwyg redactor
def fill_in_ckeditor(locator, opts)
  content = opts.fetch(:with).to_json
  page.execute_script <<-SCRIPT
  CKEDITOR.instances['#{locator}'].setData(#{content});
  $('textarea##{locator}').text(#{content});
  SCRIPT
end


class TempDeleteTestTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  setup do
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default
    Capybara.app_host = 'http://apex-news.herokuapp.com'
    page.driver.browser.manage.delete_all_cookies
    page.driver.browser.manage.window.maximize
  end
   
  test 'redactor_can_delete_post' do

    users_mail = 'redactor1@mail.ru'
    users_password = '12345678'  
    variable = ' ' + Time.now.strftime("%s")
    post_title = 'Test very long long title with some spaces '+variable
    post_content = users_mail + ': This is my message! And I want to delete it!'+
      'and it will very long post with interesting story \n So you can read it'
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
 
    visit '/posts'

    #except(find(:xpath, "/html/body/div/div/div/table/tbody/tr[1]/td[2]/a")).to have_content('Test')    
    
    accept_alert do
      find(:xpath, "//html/body/div/div/div/table/tbody/tr[1]/td[9]/a/span").click
    end
       
    #driver.
    #page.driver.switch_to.alert.accept

  end 
 
 
 
 
end
