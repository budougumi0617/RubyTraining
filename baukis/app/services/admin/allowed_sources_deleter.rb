class Admin::AllowedSourcesDeleter
  #こんなパラメータが来るのを想定している。
  #{
  #   allowed_ sources: {
  #     '0' => { id: '1', _destroy: '0' },
  #     '1' => { id: '2', _destroy: '1' },
  #     '2' => { id: '3', _destroy: '1' },
  #     '3' => { id: '4', _destroy: '0' }
  #   }
  #}

  def delete(params)
    if params && params[:allowed_sources].kind_of?(Hash)
      ids = []
      params[:allowed_sources].values.each do |hash|
        if hash[:_destroy] == '1'
          ids << hash[:id]
        end
      end
      if ids.present?
        AllowedSource.where(namespace: 'staff', id: ids).delete_all
      end
    end
  end
end
