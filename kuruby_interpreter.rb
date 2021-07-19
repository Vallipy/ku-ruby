#Interpreter for text printing and simple addition with KuRuby lang
CHAR = 0
INT = 1
OPERATION = 9

ADD = 1
SUBT = 2
MULT = 3
DIV = 4

class Token
    attr_reader :type, :value
    def initialize(type, value)
        @type = type
        @value = value
    end
    def repr
        puts @type
        puts @value
    end
end


class Lexer
    attr_reader :output
    def initialize(data_stream)
        get_tokens(data_stream)
        parse_tokens

    end

    def get_tokens(data_stream)
        _parse = data_stream.split(/ /)
        @token_collection = []

        for item in _parse
            
            _value = 0
            _type = -1
            
            if item.match(/\b[Pp]/) #pigi for char or int
                item.each_char { |c|
                    case c
                    when 'P'        # P for char, p for int
                        _type = CHAR
                    when 'p'         
                        _type = INT
                    when 'i'
                        _value += 1
                    when 'I'
                        _value += 2
                    when 'g'
                        _value += 10
                    when 'G'
                        _value += 50
                    end
                }
         
            elsif item.match(/[uU][wW][aA][hH]/) # uwah for operation
                _type = OPERATION
               if item.include? 'U'
                    _value = ADD
               end
               if item.include? 'W'
                    _value = SUBT
               end
               if item.include? 'A'
                    _value = MULT
               end
               if item.include? 'H'
                    _value = DIV
               end

               if _value == 0
                    raise ArgumentError.new 'Operation is not defined, capitalize a letter'
               end

            else
                next
            end

            @token_collection.append(Token.new(_type,_value))
        end
    end

    def parse_tokens
        @output = nil
        _is_string = nil
        _value_cache = nil
        _type_cache = nil
        _operand_cache = nil

        for token in @token_collection
            if @output.nil?
                if token.type == CHAR
                    _is_string = true
                    @output = numbered_char token.value
                elsif token.type == INT
                    _is_string = false
                    @output = token.value
                else
                    raise TypeError.new 'cannot operate on null'
                end
            else
                if _is_string
                    if token.type == OPERATION
                        raise TypeError.new 'cannot operate on string'
                    elsif token.type == INT
                        @output += token.value.to_s
                    else
                        @output += numbered_char token.value
                    end
                else #todo insert operations on ints
                    next

                end
            end
        end
    end
    
end


def prompt
    print "<Ruby> "
    return gets.chomp
end

def out(*args)
    print "[Ruby] "
    puts(*args)
end

def numbered_char(int)
    return int.chr
end

if __FILE__ == $0
    while true
        magic = nil
        input = prompt

        magic = Lexer.new(input)
        out magic.output
    end
end