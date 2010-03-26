require 'spec_helper'

describe "/events/show.html.erb" do
  include EventsHelper
  before(:each) do
    assigns[:event] = @event = stub_model(Event,
      :name => "value for name",
      :event_type => "value for event_type",
      :location => "value for location",
      :description => "value for description"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ event_type/)
    response.should have_text(/value\ for\ location/)
    response.should have_text(/value\ for\ description/)
  end
end
