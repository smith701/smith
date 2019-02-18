
{literal}

<script type="text/javascript">
    function selectAllAudio(x) 
    {
        document.formulaire.sAll.checked != document.formulaire.sAll.checked
        for(var i=0,l=x.form.length; i<l; i++)
        {
              if (x.form[i].name == 'FilenameList[]')
                x.form[i].checked=document.formulaire.sAll.checked
        }
    }
    
    function ShowOptionsFields(form)
    {
        switch (document.getElementById("ShowOptions").checked)
        {
            case true: 
            {
               document.getElementById("cadreoptions").style.display = "inline";
               break;
            }
            case false : 
            {
               document.getElementById("cadreoptions").style.display = "none";
               break;
            }
       }
    }   

 
</script>
{/literal}
