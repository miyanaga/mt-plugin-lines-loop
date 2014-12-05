mt-plugin-lines-loop
====================

Symple plugin to loop each line of text.

Example
--------

mt:LinesLoop splits text to each lines and loop them.

    <mt:LinesLoop tag="MULTI_LINES_CUSTOM_FIELD">
        <mt:LinesLoopHeader><ul></mt:LinesLoopHeader>
            <li><mt:LinesLoopLine /></li>
        <mt:LinesLoopFooter></ul></mt:LinesLoopFooter>
    </mt:LinesLoop>

Using variable
---------------

'name' modifier refers template variable.

    <mt:LinesLoop name="MULTI_LINES_VAR">
    ....
    </mt:LinesLoop>

Including blank
---------------

mt:LinesLoop ignores blank line. To include blank lines, set blank modifier.

    <mt:LinesLoop blank="1" tag="MULTI_LINES_CUSTOM_FIELD">
    <!-- including blank lines -->
    </mt:LinesLoop>

