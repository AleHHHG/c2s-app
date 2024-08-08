# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[ show edit update destroy start_scraping ]

  def index
    @pagy, @tasks = pagy(Task.by_user(@current_user[:id]).order('created_at desc'))
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
    
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      SaveNotificationEvent.new(@task.event_attributes).publish!
      redirect_to tasks_path, notice: 'Tarefa criada com sucesso'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      SaveNotificationEvent.new(@task.event_attributes).publish!
      redirect_to tasks_path, notice: 'Tarefa editada com sucesso'
    else
      render :edit, status: :unprocessable_entity 
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'Tarefa deletada com sucesso'
  end

  def start_scraping
    if @task.update(status: 'in_progress')
      CollectDataEvent.new({id: @task.id, url: @task.url, user_id: @task.user_id }).publish!
      redirect_to tasks_path, notice: 'Web Scraping - adicionado a fila de processamento'
    else
      flash[:error] = @task.errors
      redirect_to tasks_path
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:url, :user_id)
  end
end