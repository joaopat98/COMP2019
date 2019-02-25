# deiGo specification

## Tokens

 - ID: sequências alfanuméricas começadas por uma letra, onde o símbolo “_” conta como uma letra. Letras maiúsculas e minúsculas são consideradas letras diferentes.

 - INTLIT: é uma sequência de dígitos que representa uma constante inteira. Existe a opção de adicionar um prefixo para especificar outra base que não a decimal: 0 para octal, 0x ou 0X para hexadecimal. Nesta última, as letras (a-f) e (A-F) correspondem aos valores entre 10 e 15.
 - REALLIT: uma parte inteira seguida de um ponto, opcionalmente seguido de uma parte fracionária e/ou de um expoente; ou um ponto seguido de uma parte fracionária, opcionalmente seguida de um expoente; ou uma parte inteira seguida de um expoente. O expoente consiste numa das letras “e” ou “E” seguida de um número opcionalmente precedido de um dos sinais “+” ou “-”. Tanto a parte inteira como a parte fracionária e o número do expoente consistem em sequências de dígitos decimais.
 - STRLIT: uma sequência de carateres (excepto “carriage return”, “newline”, ou aspas duplas) e/ou “sequências de escape” entre aspas duplas. Apenas as sequências de escape \f, \n, \r, \t, \\\ e \\" são definidas pela linguagem. Sequências de escape não definidas devem dar origem a erros lexicais, como se detalha mais adiante.
 - SEMICOLON = “;”
 - BLANKID = “_”
 - PACKAGE = “package”
 - RETURN = “return”
 - AND = “&&”
 - ASSIGN = “=”
 - STAR = “*”
 - COMMA = “,”
 - DIV = “/”
 - EQ = “==”
 - GE = “>=”
 - GT = “>”
 - LBRACE = “{”
 - LE = “<=”
 - LPAR = “(”
 - LSQ = “[”
 - LT = “<”
 - MINUS = “-”
 - MOD = “%”
 - NE = “!=”
 - NOT = “!”
 - OR = “||”
 - PLUS = “+”
 - RBRACE = “}”
 - RPAR = “)”
 - RSQ = “]”
 - ELSE = “else”
 - FOR = “for”
 - IF = “if”
 - VAR = “var”
 - INT = “int”
 - FLOAT32 = “float32”
 - BOOL = “bool”
 - STRING = “string”
 - PRINT = “fmt.Println”
 - PARSEINT = “strconv.Atoi”
 - FUNC = “func”
 - CMDARGS = “os.Args”
 - RESERVED: palavras reservadas da linguagem Go não utilizadas em deiGo bem como o operador de incremento (“++”) e o operador de decremento (“−−”).