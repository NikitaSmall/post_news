require 'test_helper'

class DataartSchoolTest < ActionDispatch::IntegrationTest
 include Capybara::DSL

  setup do
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default
    Capybara.app_host = 'http://it-school.dataart.com/'
    page.driver.browser.manage.delete_all_cookies
    page.driver.browser.manage.window.maximize
  end
  
  test 'test_case' do
   visit '/' 
   find(:xpath, "//nav/ol/li/a[@class='cta cta-login']").click   
   fill_in('email', :with => 'yevsikov')   
   fill_in('password', :with => 'vvv347035')  
   find(:xpath, "//button[@id='submit']").click    
   find(:xpath, "//a[@class='enter-course']").click   
   find(:xpath, "//ol[@class='course-tabs']/li[1]/a").click  
   visit '/courses/DataArt/DAITSCHODx004/DataArt_IT_School_Odessa_Iteration_4/courseware/70f19b4a6b0f4a179b8da2dc435ecae0/53a3205b9bfb463294e049d7e75b9a0b/'    
   #check('Severity',1)
 

   for a in 1..2
     if a == 1 
     check("input_i4x-DataArt-DAITSCHODx004-problem-e2e46cbb3a7b4928a02c6db023e1a122_3_1_choice_10")
       #find(:xpath, "//form[@id='inputtype_i4x-DataArt-DAITSCHODx004-problem-e2e46cbb3a7b4928a02c6db023e1a122_3_1']/fieldset/label[1]").click 
       end
     
       for b in 1..2
         if b == 1
           #find(:xpath, "//form[@id='inputtype_i4x-DataArt-DAITSCHODx004-problem-e2e46cbb3a7b4928a02c6db023e1a122_3_1']/fieldset/label[2]").click 
         end
     end
       click_on('Check') 
    #find(:xpath, "//button[@id='submit']").click  
   end



  end

end
