import 'package:flutter/material.dart';
/*
home: DefaultTabController(
				length: 4,
				child: Scaffold(
					appBar: new PreferredSize(
						preferredSize: Size.fromHeight(kToolbarHeight),
						child: new Container(
							margin: const EdgeInsets.only(top: 50.0),
							height: 40.0,
							child: new TabBar(
								unselectedLabelColor: Colors.black,
								labelColor: Colors.black,
								indicatorSize: TabBarIndicatorSize.label,
								indicator: BoxDecoration(
									borderRadius: BorderRadius.circular(50),
									color: Color(0xFFE1D5CB),
								),
							tabs: [
								Tab(
									child: Container(
										decoration: BoxDecoration(
											borderRadius: BorderRadius.circular(50),
											
										),
										child: Align(
											alignment: Alignment.center,
											child: Text("home"),
										),
									),
								),
								Tab(
									child: Container(
										decoration: BoxDecoration(
											borderRadius: BorderRadius.circular(50),
										),
										child: Align(
											alignment: Alignment.center,
											child: Text("map"),
										),
									),
								),
								Tab(
									child: Container(
										decoration: BoxDecoration(
											borderRadius: BorderRadius.circular(50),
										),
										child: Align(
											alignment: Alignment.center,
											child: Text("goal"),
										),
									),
								),
								Tab(
									child: Container(
										decoration: BoxDecoration(
											borderRadius: BorderRadius.circular(50),
										),
										child: Align(
											alignment: Alignment.center,
											child: Icon(Icons.add),
										),
									),
								),
							]),	
						),
					),
					
					body: new Stack(
						children: <Widget>[
							Container(
								decoration: new BoxDecoration(
									image: new DecorationImage(
										image: new AssetImage("assets/background.jpg"), 
										fit: BoxFit.cover,
									),
								),
								margin: EdgeInsets.only(top: 0),
							),
							Center(
								child: Column(
									mainAxisAlignment: MainAxisAlignment.center,
									children: <Widget>[
										ProfileCard(),
										Image(
											image: new AssetImage("assets/timer.png"),
										),
										Text(
											'$_dayNum' + ' Days',
											style: TextStyle(
												fontSize: 30,
												color: Colors.black,
											),
										),
										Text(
											'until ' + '$_eventName',
											style: TextStyle(
												fontSize: 18,
												color: Colors.black,
											),
										),
										ProfileCard(),		
									],
								),
							),
						]
					),
					bottomNavigationBar: 
						Row(							
							mainAxisAlignment: MainAxisAlignment.spaceEvenly,
							children: <Widget>[
								IconButton(
									icon: Icon(
										Icons.home,
										color: Color(0xFF736464)
									),
									onPressed: () {},
								),
								IconButton(
									icon: Icon(
										Icons.calendar_today,
										color: Color(0xFF736464)
									),
									onPressed: () {},),
								Container(
									height: 90,
									child: CircleAvatar(
										backgroundColor: Colors.white,
									),
								),
								IconButton(
									icon: Icon(
										Icons.photo_library,
										color: Color(0xFF736464)
									),
									onPressed: () {},),
								IconButton(
									icon: Icon(
										Icons.person,
										color: Color(0xFF736464)
									),
									onPressed: () {},),
							],
						),
					floatingActionButton: Container(
						child:
							FloatingActionButton(
								onPressed: (){},
								backgroundColor: Color(0xFF736464),
								child: Icon(Icons.chat_bubble_outline)
							),
						margin: EdgeInsets.only(top: 800),
					),
					floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
			)
		)

*/
