/*
var/html = {"
<html>
    <head>
        <script>
            function updateWho(content) {
                document.getElementById('who_container').innerHTML = content;
            }
        </script>
    </head>
    <body>
        <div id="who_container">
            <noscript>
                Javascript required for the who list to function.
            </noscript>
        </div>
    </body>
</html>
"}

mob
    Login()
        ..()

        src << output(html, "who.browser")

    proc
        updateWho()
            src << output(list2params(list(new_who_list_here)), "who.browser:updateWho")

*/