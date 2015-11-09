class MessagesController < BaseController

  # POST /messages
  def create
    @message = Message.new(message_params)

    if @message.save
      @message_text = 'Сообщение отправлено'
    else
      @message_text = 'Форма заполнена неполностью'
    end

    # if @message.save
    #   redirect_to static_pages_contacts_path, notice: 'Сообщение удачно созданно.'
    # else
    #   render :new
    # end

  end

  private
    def message_params
      params.require(:message).permit(:name, :email, :message)
    end

end