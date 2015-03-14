class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :start, :end, :url

  def title
    object.name
  end

  def start
    object.started_on
  end

  def end
    object.completed_on.present? ? object.completed_on : Date.today
  end

  def completed_on
    object.completed_on.present? ? object.completed_on : Date.today
  end

  def url
    "/admin/jobs/#{object.id}"
  end
end
