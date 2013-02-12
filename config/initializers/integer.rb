class Integer
  def pad
    self.to_s.rjust(2, '0')
  end
end