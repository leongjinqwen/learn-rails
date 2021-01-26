ActiveAdmin.register_page "Room Active" do
  content do
    h2 "Activate Room/Hall"

    active_admin_form_for :room, url: admin_room_active_push_path, class: 'formtastic edit', method: :post do |f|
      safe_join [
        f.label('Select Room/Hall :', class: 'label'),
        f.select(
          :roomId, (
            {
              'Auditorium': 1,
              'Exhibition': 2,
            }.to_a
          ), { prompt: 'None' }, style: 'width: 100%; display: block; padding: 6px'
        )
      ]
      safe_join [
        f.label('Set on or off :', class: 'label'),
        f.select(
          :active, (
            {
              'On': 1,
              'Off': 0
            }.to_a
          ), { prompt: 'None' }, style: 'width: 100%; display: block; padding: 6px'
        )
      ]

      f.submit 'Submit', style: 'padding: 6px; background-color: green; margin-top: 12px;'
    end
  end

  FIREBASE_URL = Rails.application.credentials.firebase[:url]
  FIREBASE_SECRET = Rails.application.credentials.firebase[:secret]

  page_action :push, method: [:post] do
    return redirect_to(admin_room_active_path, alert: 'Both fields are required.') \
      unless params[:room][:roomId].present? & params[:room][:active].present?

    client = Firebase::Client.new(FIREBASE_URL)

    response = client.update("rooms/#{params[:room][:roomId]}", {
      active: params[:room][:active]
    })
    
    # response = client.set('auditorium', params[:notice][:active])
    # client.set => to update value of `auditorium` key
    # client.push => to create new item under `auditorium` key
    # eg. response = client.push('pushNotification', {
    #   message: params[:notice][:content],
    #   url: params[:notice][:url]
    # })

    if response.success?
      redirect_to admin_room_active_path, notice: 'Room set successfully!'
    else
      redirect_to admin_room_active_path, alert: 'Room failed to set. Please try again.'
    end
  end
end

  