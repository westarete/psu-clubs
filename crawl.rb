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

1.upto(71) do |page_number|

  # Do this for all 15 links on the page
  15.times do |link_index|

    visit "/hub/studentorgs/orgdirectory/"
    select page_number.to_s, from: "Skip to Page:"
    click_button "Go"

    # Go get the Nth link on the page
    link = page.all('table#ctl00_ContentPlaceHolder1_GridViewResults tr a')[link_index]

    next if ["Org Name", "President Name", "Category"].include?(link.text)

    link.click

    p find('#ctl00_ContentPlaceHolder1_LabelOrgName').text

  end

end