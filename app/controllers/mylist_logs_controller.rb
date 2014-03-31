class MylistLogsController < ApplicationController
  before_action :set_mylist_log, only: [:show, :edit, :update, :destroy]

  # GET /mylist_logs
  def index
    @mylist_logs = MylistLog.all
  end

  # GET /mylist_logs/1
  def show
  end

  # GET /mylist_logs/new
  def new
    @mylist_log = MylistLog.new
  end

  # GET /mylist_logs/1/edit
  def edit
  end

  # POST /mylist_logs
  def create
    @mylist_log = MylistLog.new(mylist_log_params)

    if @mylist_log.save
      redirect_to @mylist_log, notice: 'Mylist log was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /mylist_logs/1
  def update
    if @mylist_log.update(mylist_log_params)
      redirect_to @mylist_log, notice: 'Mylist log was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /mylist_logs/1
  def destroy
    @mylist_log.destroy
    redirect_to mylist_logs_url, notice: 'Mylist log was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mylist_log
      @mylist_log = MylistLog.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def mylist_log_params
      params.require(:mylist_log).permit(:mylist_id, :amount_of_view, :amount_of_mylist, :amount_of_comment)
    end
end
