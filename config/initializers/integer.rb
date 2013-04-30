class Integer
  def pad(length = 2)
    self.to_s.rjust(length, '0')
  end
end
