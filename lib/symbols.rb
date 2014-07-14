module Symbols

  def symbols_from_library(library)
  	syms = `nm #{library}`.split("\n")

  	result = classes_from_symbols(syms)
  	result += constants_from_symbols(syms)
  	return result
  end

  module_function :symbols_from_library

  :private

  def classes_from_symbols(syms)
  	classes = syms.select { |klass| klass[/OBJC_CLASS_\$_/] }
    classes = classes.select { |klass| klass !~ /_NS|_UI/ }
    classes = classes.uniq
    return classes.map! { |klass| klass.gsub(/^.*\$_/, '') }
  end

  def constants_from_symbols(syms)
  	consts = syms.select { |const| const[/ S /] }
  	consts = consts.select { |const| const !~ /OBJC|\.eh/ }
  	consts = consts.uniq
  	consts = consts.map! { |const| const.gsub(/^.*_/, '') }

  	other_consts = syms.select { |const| const[/ T /] }
  	other_consts = other_consts.uniq
  	other_consts = other_consts.map! { |const| const.gsub(/^.*_/, '') }

  	return consts + other_consts
  end

  module_function :classes_from_symbols
  module_function :constants_from_symbols

end