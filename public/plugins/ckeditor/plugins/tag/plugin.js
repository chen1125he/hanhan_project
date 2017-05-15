CKEDITOR.plugins.add('tag', {
    requires: ['dialog'],
	init: function (editor) {
		editor.addCommand('tag', new CKEDITOR.dialogCommand("tag"));

		editor.ui.addButton('tag', {
			label: 'パーツタグ',
			command: 'tag',
			//icon: this.path + 'images/icon-long.png',
		});
		CKEDITOR.dialog.add('tag', this.path + 'dialogs/d.js');
	}
});
CKEDITOR.on('instanceReady', function (e) { 
	$('.cke_button__tag .cke_button_icon').text('パーツタグ');
	function add_css(str_css) {
		try { //IE下可行
			var style = document.createStyleSheet();
			style.cssText = str_css;
		}
		catch (e) { //Firefox,Opera,Safari,Chrome下可行
			var style = document.createElement("style");
			style.type = "text/css";
			style.textContent = str_css;
			document.getElementsByTagName("HEAD").item(0).appendChild(style);
		}
	}
	add_css('.cke_button__tag .cke_button_icon { width:auto;opacity:1 }');
	add_css('.cke_button__tag.cke_button_disabled .cke_button_icon { opacity:.3 }');
})