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

    $(".clearConditions").click(function () {
        var form = $(this).parents('form');
        form.find('input')
            .not(':button, :submit, :reset, :hidden, :disabled, :checkbox, :radio')
            .val('')
            .removeAttr('checked')
            .removeAttr('selected');
        form.find('select').not(':disabled').prop('selectedIndex', -1).trigger('change'); //122017 不清除disabled的项
        form.find('#q_date_gteq').val('');
        form.find('#q_date_lteq').val('');
//        initDateRange();
        setTimeout(function () {
            form.find('input[type="checkbox"], input[type="radio"]').prop('checked', false);
            form.find('input[type="checkbox"], input[type="radio"]').iCheck('update');
        }, 0)
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
