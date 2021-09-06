setlocal suffixesadd+=.java

"
" langserver support in java
"
" ale.vim - in theory, ale should support java via 1 of 2 langservers
" https://github.com/dense-analysis/ale/blob/master/doc/ale-java.txt
" Using the above instructions for the vscode one
"
" Follow first section of instructions here
" https://github.com/georgewfraser/java-language-server
"
" coc.vim - `:CocInstall coc-java` - Seems to work, including lombok
"   :CocLocalConfig - edit project specific config
"      coc-settings.json
"      {
"         "java.jdt.ls.vmargs": "-javaagent:/usr/local/share/lombok/lombok.jar -Xbootclasspath/a:/usr/local/share/lombok/lombok.jar",
"      }
"   brew install lombok?
"
" Ideally I'd get the lombok path from gradle somehow...


" https://langserver.org/
if exists('g:ale_linters')
    " let g:ale_java_javac_options = '-Xlint -Xlint:-serial'
    " let g:ale_linters.java = ['javac', 'checkstyle']
    " let g:ale_linters.java = ['javalsp', 'checkstyle']
    " let g:ale_java_javalsp_executable = '/Users/humphs92/dev/java-language-server/dist/lang_server_mac.sh'

    let g:ale_linters.java = ['checkstyle']
endif
