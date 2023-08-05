class CompetitionGateway
  def create(competition_params)
    competition = Competition.new(competition_params)

    competition.save ? competition : competition.errors
  end

  def show_all
    Competition.all.map do |competition|
      competition.attributes.merge(
        { modality: modality(competition) },
        { participants: participants(competition) },
        { winner: winner(competition) },
        { best_results: best_results(competition) }
      ).to_virtual_record
    end
  end

  def show(id)
    competition = Competition.find_by_id(id)
    return unless competition

    competition.attributes.merge(
      { modality: modality(competition) },
      { participants: participants(competition) },
      { winner: winner(competition) },
      { all_results: all_results(competition) }
    ).to_virtual_record
  end

  def close(competition)
    comp = Competition.find_by_id(competition)
    return unless comp && comp.closed == false

    comp.update_attribute(:closed, true)

    comp
  end

  private

  def modality(competition)
    { name: competition.modality.name, unit: competition.modality.unit }
  end

  def participants(competition)
    return 0 unless competition.result&.count&.positive?

    competition.result.map(&:user).uniq.count
  end

  def best_results(competition)
    return [] unless competition.result&.count&.positive?

    competition.result.order(value: competition.modality.unit == 'seconds' ? :asc : :desc).limit(3).map(&:value)
  end

  def all_results(competition)
    return [] unless competition.result&.count&.positive?

    competition.result.order(value: competition.modality.unit == 'seconds' ? :asc : :desc).map do |result|
      { id: result.user.id, name: result.user.name, value: result.value }
    end
  end

  def winner(competition)
    return [] unless competition.result&.count&.positive? && competition.closed

    competition.result.order(value: competition.modality.unit == 'seconds' ? :asc : :desc).limit(1).map do |result|
      { name: result.user.name, value: result.value }
    end
  end
end
