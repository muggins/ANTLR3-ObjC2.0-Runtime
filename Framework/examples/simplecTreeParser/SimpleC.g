grammar SimpleC;
options {
    output=AST;
    language=ObjC;
}

tokens {
    VAR_DEF;
    ARG_DEF;
    FUNC_HDR;
    FUNC_DECL;
    FUNC_DEF;
    BLOCK;
}

program
    :   declaration+
    ;

declaration
    :   variable
    |   functionHeader ';' -> ^(FUNC_DECL functionHeader)
    |   functionHeader block -> ^(FUNC_DEF functionHeader block)
    ;

variable
    :   type declarator ';' -> ^(VAR_DEF type declarator)
    ;

declarator
    :   K_ID 
    ;

functionHeader
    :   type K_ID '(' ( formalParameter ( ',' formalParameter )* )? ')'
        -> ^(FUNC_HDR type K_ID formalParameter+)
    ;

formalParameter
    :   type declarator -> ^(ARG_DEF type declarator)
    ;

type
    :   K_INT   
    |   K_CHAR  
    |   K_VOID
    |   K_ID        
    ;

block
    :   lc='{'
            variable*
            stat*
        '}'
        -> ^(BLOCK[$lc,@"BLOCK"] variable* stat*)
    ;

stat: forStat
    | expr ';'!
    | block
    | assignStat ';'!
    | ';'!
    ;

forStat
    :   K_FOR '(' start=assignStat ';' expr ';' next=assignStat ')' block
        -> ^(K_FOR $start expr $next block)
    ;

assignStat
    :   K_ID K_EQ expr -> ^(K_EQ K_ID expr)
    ;

expr:   condExpr
    ;

condExpr
    :   aexpr ( (K_EQEQ^ | K_LT^) aexpr )?
    ;

aexpr
    :   atom ( K_PLUS^ atom )*
    ;

atom
    : K_ID      
    | K_INT      
    | '(' expr ')' -> expr
    ; 

K_FOR : 'for' ;
K_INT_TYPE : 'int' ;
K_CHAR: 'char';
K_VOID: 'void';

K_ID  :   ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
    ;

K_INT :	int+=('0'..'9')+ {NSLog(@"\%@", $int);}
    ;

K_EQ   : '=' ;
K_EQEQ : '==' ;
K_LT   : '<' ;
K_PLUS : '+' ;

WS  :   (   ' '
        |   '\t'
        |   '\r'
        |   '\n'
        )+
        { $channel=99; }
    ;    
