![Sweet Smash Screenshot](/Screenshot/sample1.png "Sweet Smash Screenshot")
<h1>Sweet Smash - Flash (Beta)</h1>

<i>Original Programming and Artwork by Matthew Farmer (MFarmer)</i><br>
<i>The source code is released under the <a href="http://www.gnu.org/licenses/gpl-2.0.html">GPL-v2 License</a>.</i>

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

Sweet Smash is my first Flash game effort, and was primarily developed as a learning experience. I had created an <a href="cs2.mwsu.edu/~mfarmer/web_course/sweetsmash/">HTML5 version</a> of this game first for a web development course at my university, and afterwards decided to port the game to ActionScript 3.0. By porting the game, I was able to better understand the inherent similarities/differences between developing a game in Flash vs. HTML5.

<h3>TODO</h3>
<ul>
	<li>Implement both music, more sound effects, and a sound toggle button</li>
	<li>Introduce power-ups to spice up gameplay a bit</li>
	<li>Add more dynamic, graphical feedback when the player amasses long combo streaks or high scoring moves, such as a combo streak counter, flashing lights, etc.</li>
</ul>

<h3>Known Bugs</h3>
<ul>
	<li>Rarely, a sweet will swap incorrectly, leaving a blank spot on the grid and crashing the game.</ul>
	<li>If a match of 4 or more sweets occurs during an automatic 'refilling' of the board (in other words, not something which occurred directly from a player move), a jelly bean appears at the location of the player's last move rather than where the 4+ match occurred. Fixing this will require refactoring the findRowMatches/findColMatches functions to better record and act on these occurrences.</li>
</ul>
