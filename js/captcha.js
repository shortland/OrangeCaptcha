var captcha_selected = [];

$(window).ready(function() {
	captcha_getnew();
});

function captcha_submit() {
	$.post("validate.pl", {
		captcha1: captcha_selected[0], 
		captcha2: captcha_selected[1],
		captcha3: captcha_selected[2]
	}).done(function(data) {
		$("#captcha_res").html(data);
	});
	captcha_getnew();
}

function captcha_getnew() {
	$("#captcha_holder").load("captcha.pl", function() {
		$('.captcha_imgs').each(function() {
			$(this).css({})
		});
	});
	captcha_selected = [];
}

function captcha_click(idn) {
	var selector = "#" + idn;
	if ($(selector).hasClass('captcha_selected')) {
		$(selector).removeClass('captcha_selected');
		for (var i = 0; i < captcha_selected.length; i++) {
			if (captcha_selected[i] == idn) captcha_selected.splice(i, 1); 
		}
	}
	else {
		if (captcha_selected.length == 3) {
			//alert("You've already selected 3 items. Click on an item again to unselect it.");
			return;
		}
		$(selector).addClass('captcha_selected');
		captcha_selected.push(idn);
	}
}