class Heliodor::Query
  private

  def _gen
    @dat = []
  end

  def _filter(&_block)
    dat = []
    @dat.each do |item|
      dat << item if yield(item)
    end
    @dat = dat
  end

  def _select(dat = {})
    out = []
    @dat.each do |item|
      out << item if item.class.ancestors.include?(Hash) && item >= dat
    end
    @dat = out
  end

  def _update(dat1 = {}, dat2 = {})
    @dat.each_with_index do |v, k|
      @dat[k] = v.merge(dat2) if v.class.ancestors.include?(Hash) && v >= dat1
    end
  end

  def _map(&_block)
    @dat.each_with_index do |v, k|
      @dat[k] = yield(v)
    end
  end

  def _reduce(&_block)
    @dat = [@dat.reduce(&block)]
  end

  def _insert(dat)
    dat.each do |d|
      @dat << d
    end
  end

  def _rename(to)
    @full[to] = @dat
    @full.delete(@table)
    @table = to
    @dat = @full[@table]
  end

  def _delete(dat)
    d = @dat
    @dat = d.map do |i|
      if dat.class == Hash
        if i >= dat
          nil
        else
          i
        end
      else
        if i == dat
          nil
        else
          i
        end
      end
    end
    @dat.delete(nil)
    @dat
  end

  def _write
    @full[@table] = @dat
    @db.write(@full)
  end

  def _process
    actions.each do |action|
      case action['type']
      when 'create'
        _gen
      when 'ensure'
        _gen unless @dat
      when 'filter'
        _filter(&action['block'])
      when 'select'
        _select(action['dat'])
      when 'update'
        _update(action['dat1'], action['dat2'])
      when 'map'
        _map(&action['block'])
      when 'reduce'
        _reduce(&action['block'])
      when 'insert'
        _insert(action['data'])
      when 'rename'
        _rename(action['to'])
      when 'delete'
        _delete(action['dat'])
      when 'write'
        _write
      else
        raise NotImplementedError,
              "Action `#{action['type']}` is not yet implemented!"
      end
    end
  end
end
