![Screenshot](https://github.com/MFarmer/SweetSmash-Flash/master/Screenshot/sample1.png)
<h1>Sweet Smash (Flash Version)</h1>
======

<h3>What is Sweet Smash?</h3>

Sweet Smash is a puzzle game written in ActionScript 3.0.

<h3>Objective</h3>
The objective of the game is to score as many points as possible by swapping neighboring individual sweets strategically into positions so that at least one row or column of 3, 4, or 5 matching sweets is created. When such a match occurs, the sweets are said to be packaged together, and the player's score is increased by 25 points per matched sweet. In addition, the matched sweets are removed from the board, and the board repopulates with new sweets and settles existing sweets into new positions. Once the board has repopulated itself with new sweets to take the place of the matched ones, the player may make another move until all 50 moves have been made. Once there are no more moves, the player's score is tallied and a new game begins.

The player's best score, time, and total play count are recorded during the player's current session. However, these values are not persistent, and will disappear when the game is closed.

<h3>Rules</h3>
<ol>
	<li>A sweet may only be moved one space up, down, left or right.</li>
	<li>No diagonal moves are allowed.</li>
	<li>A sweet may only be moved IF a match is created after the sweet is swapped with a neighboring sweet.</li>
	<li>If a match of 4 or 5 sweets is made, one of the middle matched sweets becomes a jelly bean.</li>
	<li>If three or more jelly beans are matched together, the entire row/column is matched (depending upon the orientation of the matched jelly beans) and a magical, bouncing jelly bean is left behind.</li>
	<li>If a magical, bouncing jelly bean is matched with ANY other type of jelly beans, the entire grid is matched.</li>
</ol>

<h3>Author's Comments</h3>

This game is my first Flash game effort, and was written primarily as a learning opportunity. I had created an HTML5 version of this game first for a web development course at my university, and decided to port it to ActionScript 3.0 to learn the inherent similarities/differences between developing a game in Flash vs. HTML5.

<h3>TODO</h3>
<ul>
	<li>It'd be nice to have music and a sound toggle button</li>
	<li>Introduce power-ups to spice up gameplay a bit</li>
	<li>Add more dynamic, graphical feedback when the player amasses long combo streaks or high scoring moves, such as a combo streak counter, flashing lights, etc.</li>
</ul>

<h3>Known Bugs</h3>
<ul>
	<li>Rarely, the game will lock up after a player has made a move, which can only be fixed by refreshing the page. This tends to happen in the opening move of a game.</li>
</ul>