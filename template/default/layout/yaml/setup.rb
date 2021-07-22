require_relative "./method.rb"

def init
  @object = options.item
  @methods = @object.children.select { |child| child.type == :method }
  @methods.reject! do |method| 
    method.visibility == :private || method.tags.any? { |tag| tag.tag_name == "private" }
  end

  @constants = @object.children.select { |child| child.type == :constant }
  @references = @object.children.reject { |child| [:method, :constant].include? child.type }
  @object_text = ERB.new(File.read"#{__dir__}/_object.erb").result binding
  # if @object.name.to_s == "ImageAnnotator"
  # #   puts @object.methods.sort
  # #   p @object.docstring
  # #   puts ""
  # #   p @object.base_docstring
  # # puts ""
  # #   puts @object.attributes
  #   puts @object.docstring.class
  #   puts @object.docstring.methods.sort - "".methods
  #   puts @object.docstring.display
  #   puts @object.docstring.display.class
  #   puts @object.docstring.encoding
  #   puts @object.docstring.object.methods.sort - methods
  #   puts @object.line

  #   exit
  # end

  # # puts @object.methods.sort
  # # exit
  @method_text = @methods.map { |method|
    @method = method
    # puts method.methods.sort - methods
    puts method.signature
    # exit
    # puts method.methods.sort - methods
    # puts method.docstring
    # puts ""
    # method.tags.each do |tag|
    #   p tag
    # end
    # puts ""
    # exit
    ERB.new(File.read"#{__dir__}/_method.erb").result binding
  }.join("\n")


  @constant_text = @constants.map { |constant|
    @constant = constant
    ERB.new(File.read"#{__dir__}/_constant.erb").result binding
  }.join("\n")

  if @references.empty?
    @reference_text = "[]"
  else
    @reference_text = "\n" + @references.map { |reference|
      @reference = reference
      ERB.new(File.read "#{__dir__}/_reference.erb").result binding
    }.join("\n")
  end

  # @methods.each do |meth|
  #   if meth.writer?
  #     p meth
  #   end
  # end

  sections :layout
end

def children
  if !@object.children || @object.children.empty?
    "[]"
  else
    list = @object.children
    list.reject! do |child| 
      child.type == :method && (child.visibility == :private || child.tags.any? { |tag| tag.tag_name == "private" })
    end
    list.reject! do |child|
      child.type == :method && child.writer?
    end
    out = "\n"
    out += @object.children.map { |child|
      "      - #{child.path}"
    }.join("\n")
    out
  end
end

def docstring obj
  # str = obj.docstring.to_str.chomp.sub("--- ", "").sub("|-\n", "").gsub '"', "'"
  str = single_quotes obj.docstring.to_str
  str = fix_links str
  begin
    codeblock str
  rescue StandardError => e
    p e
  end
end

def single_quotes str
  str.gsub '"', "'"
end

def codeblock str
  return str 
  lines = str.split "\n"
  i = 0
  out = []
  code = []
  while i < lines.size
    line = lines[i]
    if line.start_with? "    "
      code << line
      if i + 1 == lines.size
        code.map! { |l| l.sub "    ", "" }
        code[0] = '<pre class="prettyprint lang-rb">' + code.first
        code[code.size - 1] = code.last + '<\pre>'
        out << code.join("\n")
        p code
        code = []
      end
    else
      if code.empty?
        out << line
      else
        code.map! { |l| l.sub "    ", "" }
        code[0] = '<pre class="prettyprint lang-rb">' + code.first
        code[code.size - 1] = code.last + '<\pre>'
        out << code.join("\n")
        p code
        code = []
      end
    end
    i += 1
  end
  out[out.size - 1] = out.last + '<\pre>' unless code.empty?
  out.join "\n"
end



def fix_links str
  str.gsub /http.*googleapis.dev\/ruby\/(google-cloud.*\))/, 'https://cloud.devsite.corp.google.com/ruby/docs/reference/\1'
end

def method_signature
  text = "#"
  text += @method.name.to_s
  params = @method.tags.select { |tag| tag.tag_name == "param" }
  text += "(" unless params.empty?
  text += params.map { |param| "#{param.name}:" }.join(", ")
  text += ")" unless params.empty?
  returns = @method.tags.select { |tag| tag.tag_name == "return" }
  return_types = []
  returns.each { |entry| return_types += entry.types }
  return_types.uniq!
  text += " => "
  text += return_types.join(", ")
  text
end

def param_text
  text = []
  params = @method.tags.select { |tag| tag.tag_name == "param" }
  params.each do |param|
    text << "- id: #{param.name.to_s}"
    text << "  type:"
    param.types.each do |type|
      text << "    - \"#{type}\""
    end
    text << "  description: \"#{single_quotes param.text}\"" unless param.text.empty?
  end

  return "        []" if text.empty?
  text.map { |line| line = "        #{line}" }.join("\n")
end

def return_text
  text = []
  returns = @method.tags.select { |tag| tag.tag_name == "return" }
  returns.each do |entry|
    text << "  type:"
    entry.types.each do |type|
      text << "    - \"#{type}\""
    end
    text << "  description: \"#{single_quotes entry.text}\"" unless entry.text.empty?
  end

  return "        []" if text.empty?
  text.map { |line| line = "        #{line}" }.join("\n")

end
