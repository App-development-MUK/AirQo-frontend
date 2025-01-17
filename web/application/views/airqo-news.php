<!--buzen-logo-->
<div class="buzen-logo" id="buzen-logo">
	<div class="container">
		<div class="row">
			<div class="col-sm-12 col-md-12 col-lg-12">
				<form method="POST" action="#">
					<input type="text" id="search-value" name="search" class="form-control" placeholder="Your town, City, District..." required>
					<button class="btn btn-default pull-right" name="submit"> <i class="fa fa-search"></i> </button>
				</form>
				<br>
				<div class="hide" id="search-results">
					
				</div>
			</div>
		</div>
	</div>
</div>
<!--buzen-logo-->

<div class="buzen-header">
	<div class="container">
		<div class="row">
			<p class="top-header"> <b>News </b></p>
		</div>
	</div>
</div>
<div class="buzen-current-projects all-projects">
	<div class="container">
		<div class="project-big-tile">
			<div class="myrow">
				<div class="row">
					<div class="card-deck">
					<?php
					foreach ($news as $row) {
						// $image = base_url() . 'assets/images/news/' . $row['news_image'];
						// if(@getimagesize($image)){
						// 	//image exists!
						// 	$image = $image;
						// }else{
						// 	//image does not exist.
						// 	$image = base_url() . 'assets/frontend/images/placeholder.png';
						// }
						$image = base_url() . 'assets/frontend/images/placeholder.png';
						?>
						<div class="card col-md-4" style="padding-bottom: 5em;">
							<img src="<?= base_url(); ?>assets/images/news/<?= $image; ?>" class="thumbnail img-responsive" style="height: 250px; object-fit: cover;" alt="...">
							<div class="card-body">
								<h5 class="card-title" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><b><?= $row['news_title']; ?></b></h5>
								<p><a href="<?= site_url('news/' . $row['news_slug']); ?>" class="btn btn-primary btn-block btn-xs">Details</a></p>
							</div>
						</div>
					<?php } ?>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>