require 'capybara/dsl'
require 'capybara/poltergeist'

# Tell capybara to use css selectors, as opposed to xpath
Capybara.default_selector = :css

include(Capybara::DSL)

Capybara.app_host = "http://studentaffairs.psu.edu"
Capybara.run_server = false
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end
Capybara.current_driver = :poltergeist

visit "/hub/studentorgs/orgdirectory/"
select "2", from: "Skip to Page:"
click_button "Go"

save_screenshot 'page2.png'

