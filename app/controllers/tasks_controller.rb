class TasksController < ApplicationController
  before_action :set_task, only:[:show, :edit, :update, :destroy]

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page]).per(20)
    puts "Job Regist"
    SampleJob.perform_later

    respond_to do |format|
      format.html
      format.csv { send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv" }
    end
  end

  def import
    current_user.tasks.import(params[:file])
    redirect_to tasks_url, notice: "タスクを追加しました"
  end
  
  def show
  end
  
  def new
    @task = Task.new
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end
  
  def create
    @task = current_user.tasks.new(task_params)

    # 戻るボタン押下
    if params[:back].present?
      render :new
      return
    end

    # 登録ボタン押下
    if @task.save
      logger.debug "task: #{@task.attributes.inspect}"
      TaskMailer.creation_email(@task).deliver_now
      redirect_to tasks_url, notice: "タスク 「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    @task.update!(task_params)
    redirect_to task_url, notice: "タスク「#{@task.name}」を更新しました。"
  end
  
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{task.name}」を削除しました。"
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
  
  def task_params
    params.require(:task).permit(:name, :description, :image)
  end

  def task_logger
    @task_logger ||= Logger.new('log/task.log', 'daily')
  end

end
