require 'csv'
require 'progressbar'
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

pbar = ProgressBar.new("clubs", 71*15)

CSV.open("clubs.csv", "wb") do |csv|
  # Print header to CSV
  csv << [ "Organication Name", "Category", "Office Address", "Office Phone", "Mission", "Website" ]

  # Visit every page of results
  1.upto(71) do |page_number|

    # Do this for all 15 links on the results page
    15.times do |link_index|

      # Visit the current page of search results
      visit "/hub/studentorgs/orgdirectory/"
      select page_number.to_s, from: "Skip to Page:"
      click_button "Go"

      # Go get the Nth organization link on the page
      link = page.all('table#ctl00_ContentPlaceHolder1_GridViewResults tr a')[link_index]

      # The table headers have links too…
      next if ["Org Name", "President Name", "Category"].include?(link.text)

      # Actually visit the organization page
      link.click

      # Harvest the organization's data:

      organization_name = find('#ctl00_ContentPlaceHolder1_LabelOrgName').text

      # Fetch all rows in the organization's info table
      rows = page.all('table#ctl00_ContentPlaceHolder1_DetailsViewOrgInfo tr')

      # Extract the text of the last column from each row that we care about.
      category       = rows[0].all('td').last.text
      office_address = rows[1].all('td').last.text
      office_phone   = rows[2].all('td').last.text
      mission        = rows[3].all('td').last.text
      website        = rows[4].all('td').last.text

      csv << [organization_name, category, office_address, office_phone, mission, website]

      pbar.inc
    end

  end

end

pbar.finish