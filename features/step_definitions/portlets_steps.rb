# Steps for portlet.features
When /^I delete that portlet$/ do
  # cms_portlet_path(@subject) seemed to create a wrong path: /cms/portlets.1 rather than the below statement
  page.driver.delete "/cms/portlets/#{@subject.id}"
end

# Why oh why does path lookup with engines not work (i.e. want to say portlet_path(@subject))
When /^I view that portlet$/ do
  visit "/cms/portlets/#{@subject.id}"
end

When /^I edit that portlet$/ do
  visit "/cms/portlets/#{@subject.id}/edit"
end

When /^I visit that page$/ do
  assert_not_nil @last_page, "Couldn't find @last_page to visit. Check the order on steps'"
  visit @last_page.path
end


Given /^a page with a portlet that raises a Not Found exception exists$/ do
  @last_page = create(:public_page)
  @raises_not_found = create(:portlet, :code => 'raise ActiveRecord::RecordNotFound', :template=>"I shouldn't be shown.'")
  @last_page.add_content(@raises_not_found)
  @last_page.publish!
  assert @last_page.published?
end

When /^a page with a portlet that raises an Access Denied exception exists$/ do
  @last_page = create(:public_page)
  @raises_access_denied = create(:portlet, :code => 'raise Cms::Errors::AccessDenied', :template=>"I shouldn't be shown.'")
  @last_page.add_content(@raises_access_denied)
  @last_page.publish!
  assert @last_page.published?
end

When /^a page with a portlet that display "([^"]*)" exists$/ do |view|
  @last_page = create(:public_page)
  portlet = create(:portlet, :template=>view)
  @last_page.add_content(portlet)
  @last_page.publish!
  assert @last_page.published?
end

When /^a page with a portlet that raises both a 404 and 403 error exists$/ do
  @last_page = create(:public_page)
  @raises_not_found = create(:portlet, :code => 'raise ActiveRecord::RecordNotFound', :template=>"I shouldn't be shown.'")
  @last_page.add_content(@raises_not_found)
  @raises_access_denied = create(:portlet, :code => 'raise Cms::Errors::AccessDenied', :template=>"I shouldn't be shown.'")
  @last_page.add_content(@raises_access_denied)
  @last_page.publish!
  assert @last_page.published?
end

When /^a page with a portlet that raises both a 403 and any other error exists$/ do
  @last_page = create(:public_page)
  @raises_not_found = create(:portlet, :code => 'raise "A Generic Error"', :template=>"I shouldn't be shown.'")
  @last_page.add_content(@raises_not_found)
  @raises_access_denied = create(:portlet, :code => 'raise Cms::Errors::AccessDenied', :template=>"I shouldn't be shown.'")
  @last_page.add_content(@raises_access_denied)
  @last_page.publish!
  assert @last_page.published?
end

Given /^there is a portlet that uses a helper$/ do
  @page_path = "/with-helper"
  @portlet = create(:portlet_with_helper, page_path: @page_path)

end
When /^I view that page$/ do
  visit @page_path
end

Then /^I should see the portlet helper rendered in the view$/ do
  assert page.has_content?(UsesHelperPortletHelper::EXPECTED_CONTENT)
end

Given /^there is a portlet that sets a custom page title like so:$/ do |body_we_are_ignoring|
  @page_path = "/portlet/custom-page-title"
  @portlet = create(:portlet_with_helper, page_path: @page_path)
end