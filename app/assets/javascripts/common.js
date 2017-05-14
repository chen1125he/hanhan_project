$(function(){
    $(document).ajaxStart(function(){
        loading(true);
    }).ajaxStop(function(){
        loading(false);
    })
    $('.flat').iCheck({
        labelHover : true,
        cursor : true,
        checkboxClass : 'icheckbox_flat',
        radioClass : 'iradio_flat'
    });
    $(".datepicker").datepicker({
        format: 'yyyy-mm-dd',
        autoclose: true,
        forceParse: true,
        minView: 'month',
        language: 'cn'
    });
})

function img_preview(file, img_container){
    var prevDiv = document.getElementById(img_container);
    if (file.files && file.files[0]){
        var reader = new FileReader();
        reader.onload = function(evt){
            prevDiv.innerHTML = '<img src="' + evt.target.result + '" />';
        }
        reader.readAsDataURL(file.files[0]);
    }else{
        prevDiv.innerHTML = '<div class="img" style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale,src=\'' + file.value + '\'"></div>';
    }
}

function loading(bool){
    if(bool){
        $("#loading").show();
    }else{
        $("#loading").hide();
    }
}
