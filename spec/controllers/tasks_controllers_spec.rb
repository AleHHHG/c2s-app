# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:task) { create(:task) }
  let(:save_nofication_double) { instance_double(SaveNotificationEvent, publish!: true) }
  let(:collect_data_double) { instance_double(CollectDataEvent, publish!: true) }

  before do
    #Autentication
    request.env[:current_user] = { id: 1 }
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: task.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: task.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Task" do
        expect(SaveNotificationEvent).to receive(:new).and_return(save_nofication_double)
        expect {
          post :create, params: { task: attributes_for(:task, user_id: 1) }
        }.to change(Task, :count).by(1)
        expect(save_nofication_double).to have_received(:publish!)
      end

      it "redirects to the tasks list" do
        expect(SaveNotificationEvent).to receive(:new).and_return(save_nofication_double)
        post :create, params: { task: attributes_for(:task, user_id: 1) }
        expect(response).to redirect_to(tasks_path)
        expect(save_nofication_double).to have_received(:publish!)
      end
    end

    context "with invalid params" do
      it "renders the new template" do
        post :create, params: { task: attributes_for(:task, url: nil, user_id: 1) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid params" do
      it "updates the requested task" do
        expect(SaveNotificationEvent).to receive(:new).and_return(save_nofication_double)
        patch :update, params: { id: task.id, task: { url: 'http://newurl.com' } }
        task.reload
        expect(task.url).to eq('http://newurl.com')
        expect(save_nofication_double).to have_received(:publish!)
      end

      it "redirects to the tasks list" do
        expect(SaveNotificationEvent).to receive(:new).and_return(save_nofication_double)
        patch :update, params: { id: task.id, task: { url: 'http://newurl.com' } }
        expect(response).to redirect_to(tasks_path)
        expect(save_nofication_double).to have_received(:publish!)
      end
    end

    context "with invalid params" do
      it "renders the edit template" do
        patch :update, params: { id: task.id, task: { url: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested task" do
      expect {
        delete :destroy, params: { id: task.id }
      }.to change(Task, :count).by(0)
    end

    it "redirects to the tasks list" do
      delete :destroy, params: { id: task.id }
      expect(response).to redirect_to(tasks_path)
    end
  end

  describe "POST #start_scraping" do
    context "when the update is successful" do
      it "updates the task status and publishes the event" do
        expect(CollectDataEvent).to receive(:new).with({ id: task.id, url: task.url, user_id: task.user_id }).and_return(collect_data_double)
        post :start_scraping, params: { id: task.id }
        task.reload
        expect(task.status).to eq('in_progress')
        expect(response).to redirect_to(tasks_path)
        expect(collect_data_double).to have_received(:publish!)
      end
    end

    context "when the update fails" do
      it "redirects to the tasks list with an error" do
        allow_any_instance_of(Task).to receive(:update).and_return(false)
        post :start_scraping, params: { id: task.id }
        expect(response).to redirect_to(tasks_path)
      end
    end
  end
end