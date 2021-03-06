require 'spec_helper'

describe ContactsController do

  def mock_admin_user(stubs={})
    @mock_admin_user ||= mock_model(User, stubs.merge({:is_admin? => true}))
  end

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs.merge({:is_admin? => false}))
  end

  def mock_contact(stubs={})
    @mock_contact ||= mock_model(Contact, stubs.merge(:first_name => "joe", :name => "joe", :user => mock_user))
  end

  def mock_other_contact(stubs={})
    @mock_other_contact ||= mock_model(Contact, stubs.merge(:first_name => "john", :name => "john", :user => mock_admin_user))
  end

  describe "when logged in as admin" do
    before do
      controller.stub!(:current_user).and_return(mock_admin_user)
    end

    describe "GET index" do
      it "assigns contacts as @contacts" do
        Contact.stub!(:paginate).and_return([mock_contact].paginate)
        get :index
        assigns[:contacts].should == [mock_contact]
      end
    end

    describe "GET show" do
      it "assigns the requested contact as @contact" do
        Contact.stub!(:find).with("37").and_return(mock_contact)
        get :show, :id => "37"
        assigns[:contact].should equal(mock_contact)
      end
    end

    describe "GET new" do
      it "assigns a new contact as @contact" do
        Contact.stub!(:new).and_return(mock_contact)
        get :new
        assigns[:contact].should equal(mock_contact)
      end
    end

    describe "GET edit" do
      it "assigns the requested contact as @contact" do
        Contact.stub!(:find).with("37").and_return(mock_contact)
        get :edit, :id => "37"
        assigns[:contact].should equal(mock_contact)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "assigns a newly created contact as @contact" do
          Contact.stub!(:new).with({'these' => 'params'}).and_return(mock_contact(:save => true))
          post :create, :contact => {:these => 'params'}
          assigns[:contact].should equal(mock_contact)
        end

        it "redirects to the created contact" do
          Contact.stub!(:new).and_return(mock_contact(:save => true))
          post :create, :contact => {}
          response.should redirect_to(contact_url(mock_contact))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved contact as @contact" do
          Contact.stub!(:new).with({'these' => 'params'}).and_return(mock_contact(:save => false))
          post :create, :contact => {:these => 'params'}
          assigns[:contact].should equal(mock_contact)
        end

        it "re-renders the 'new' template" do
          Contact.stub!(:new).and_return(mock_contact(:save => false))
          post :create, :contact => {}
          response.should render_template('new')
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested contact" do
          Contact.should_receive(:find).with("37").and_return(mock_contact)
          mock_contact.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :contact => {:these => 'params'}
        end

        it "assigns the requested contact as @contact" do
          Contact.stub!(:find).and_return(mock_contact(:update_attributes => true))
          put :update, :id => "1"
          assigns[:contact].should equal(mock_contact)
        end

        it "redirects to the contact" do
          Contact.stub!(:find).and_return(mock_contact(:update_attributes => true))
          put :update, :id => "1"
          response.should redirect_to(contact_url(mock_contact))
        end
      end

      describe "with invalid params" do
        it "updates the requested contact" do
          Contact.should_receive(:find).with("37").and_return(mock_contact)
          mock_contact.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :contact => {:these => 'params'}
        end

        it "assigns the contact as @contact" do
          Contact.stub!(:find).and_return(mock_contact(:update_attributes => false))
          put :update, :id => "1"
          assigns[:contact].should equal(mock_contact)
        end

        it "re-renders the 'edit' template" do
          Contact.stub!(:find).and_return(mock_contact(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested contact" do
        Contact.should_receive(:find).with("37").and_return(mock_contact)
        mock_contact.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the contacts list" do
        Contact.stub!(:find).and_return(mock_contact(:destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(contacts_url)
      end
    end
  end
  
  describe "when logged in as regular user" do
    before do
      controller.stub!(:current_user).and_return(mock_user)
    end

    describe "GET index" do
      it "assigns contacts as @contacts" do
        Contact.stub!(:paginate).and_return([mock_contact].paginate)
        get :index
        assigns[:contacts].should == [mock_contact]
      end
    end

    describe "GET show" do
      it "assigns the requested contact as @contact" do
        Contact.stub!(:find).with("37").and_return(mock_contact)
        get :show, :id => "37"
        assigns[:contact].should equal(mock_contact)
      end
    end

    describe "GET new" do
      it "redirects to index" do
        get :new
        response.should redirect_to(contacts_url)
      end      
    end

    describe "GET edit" do
      it "is not allowed if not user owned contact" do
        Contact.stub!(:find).with("3").and_return(mock_other_contact)
        get :edit, :id => "3"
        response.should redirect_to(contacts_url)
      end
      
      it "assigns the requested contact as @contact" do
        Contact.stub!(:find).with("37").and_return(mock_contact)
        get :edit, :id => "37"
        assigns[:contact].should equal(mock_contact)
      end
    end

    describe "POST create" do
      describe "with any params" do
        it "redirects to index" do
          post :create, :contact => {:these => 'params'}
          response.should redirect_to(new_user_session_url)
        end
      end
    end

    describe "PUT update" do
      it "is not allowed if not user owned contact" do
        Contact.stub!(:find).with("3").and_return(mock_other_contact)
        put :update, :id => "3", :contact => {:these => 'params'}
        response.should redirect_to(contacts_url)
      end
      
      describe "with valid params" do
        it "updates the requested contact" do
          Contact.should_receive(:find).with("37").and_return(mock_contact)
          mock_contact.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :contact => {:these => 'params'}
        end

        it "assigns the requested contact as @contact" do
          Contact.stub!(:find).and_return(mock_contact(:update_attributes => true))
          put :update, :id => "1"
          assigns[:contact].should equal(mock_contact)
        end

        it "redirects to the contact" do
          Contact.stub!(:find).and_return(mock_contact(:update_attributes => true))
          put :update, :id => "1"
          response.should redirect_to(contact_url(mock_contact))
        end
      end

      describe "with invalid params" do
        it "updates the requested contact" do
          Contact.should_receive(:find).with("37").and_return(mock_contact)
          mock_contact.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :contact => {:these => 'params'}
        end

        it "assigns the contact as @contact" do
          Contact.stub!(:find).and_return(mock_contact(:update_attributes => false))
          put :update, :id => "1"
          assigns[:contact].should equal(mock_contact)
        end

        it "re-renders the 'edit' template" do
          Contact.stub!(:find).and_return(mock_contact(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end
    end

    describe "DELETE destroy" do
      it "redirects to the contacts list" do
        Contact.should_not_receive(:find)
        delete :destroy, :id => "1"
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "when not logged in" do
    before do
      controller.stub!(:current_user).and_return(nil)
    end

    describe "GET index" do
      it "assigns contacts as @contacts" do
        Contact.stub!(:paginate).and_return([mock_contact].paginate)
        get :index
        assigns[:contacts].should == [mock_contact]
      end
    end

    describe "GET show" do
      it "assigns the requested contact as @contact" do
        Contact.stub!(:find).with("37").and_return(mock_contact)
        get :show, :id => "37"
        assigns[:contact].should equal(mock_contact)
      end
    end

    describe "GET new" do
      it "redirects to login" do
        get :new
        response.should redirect_to(new_user_session_url)
      end
    end

    describe "GET edit" do
      it "redirects to login" do
        Contact.should_not_receive(:find)
        get :edit, :id => "1"
        response.should redirect_to(new_user_session_url)
      end
    end

    describe "POST create" do
      describe "with any params" do
        it "redirects to index" do
          post :create, :contact => {:these => 'params'}
          response.should redirect_to(new_user_session_url)
        end
      end
    end

    describe "PUT update" do
      describe "with any params" do
        it "redirects to index" do
          Contact.should_not_receive(:find)
          put :update, :id => "37", :contact => {:these => 'params'}
          response.should redirect_to(new_user_session_url)
        end
      end
    end

    describe "DELETE destroy" do
      it "redirects to index" do
        delete :destroy, :id => "37"
        response.should redirect_to(new_user_session_url)
      end

      it "should not delete any contacts" do
        Contact.should_not_receive(:find)
        delete :destroy, :id => "1"
      end
    end
  end
end
