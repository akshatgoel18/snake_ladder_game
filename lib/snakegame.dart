import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  @override
  final int squareperrow=20;
  final int squarepercol=40;
  final fontstyle =TextStyle(fontSize: 20,color: Colors.white);
  final randomgen=Random();
  var snake=[[0,1],[0,0]];
  var food=[0,2];
  var direction="up";
  bool isplaying=false;
  void startgame()
  {
  const duration=Duration(milliseconds: 200);
  snake=[
    [(squareperrow/2).floor(),(squarepercol/2).floor()]
  ];
  snake.add([(squareperrow/2).floor(),(squarepercol/2).floor()+1]);
  createfood();
  isplaying=true;
   Timer.periodic(duration, (timer) {
    movesnake();
    if(checkgameover())
    {
      timer.cancel();
      endgame();
    }
  });


  }
  bool checkgameover()
  {
    if(!isplaying || snake[0][0]<0 || snake[0][0]>=squareperrow || snake[0][1]<0 || snake[0][1]>=squarepercol)
      return true;
    for(int i=1;i<snake.length;i++)
      {
        if(snake[i][0]==snake[0][0] && snake[i][1]==snake[0][1])
          return true;
      }
    return false;
  }
  void endgame()
  {
    isplaying=false;
    showDialog(context:context,
    builder: ((BuildContext context){
      return AlertDialog(
       title: Text("Game Over"),
       content: Text(
         'Score:${snake.length-2}',
         style: TextStyle(color: Colors.black,fontSize: 20),
       ),
        actions: <Widget>[
          FlatButton(
            child:Text("close"),
            onPressed: (){

              Navigator.of(context).pop();
              setState(() {
                snake=[[0,1],[0,0]];
                food=[0,2];

              });
            },
          )
        ],
      );
    }),
    );
  }
  void movesnake()
  {
    setState(() {

      switch(direction)
      {
        case "up":
          snake.insert(0,[snake[0][0],snake[0][1]-1]);
          break;
        case "down":
          snake.insert(0, [snake[0][0],snake[0][1]+1]);
          break;
        case "right":
          snake.insert(0, [snake[0][0]+1,snake[0][1]]);
          break;
        case "left":
          snake.insert(0, [snake[0][0]-1,snake[0][1]]);
          break;
      }
      if(snake[0][0]!=food[0] || snake[0][1]!=food[1])
        snake.removeLast();
      else
        createfood();
    });
  }
  void createfood()
  {
    food=[randomgen.nextInt(squareperrow),randomgen.nextInt(squarepercol)];
  }
  Widget build(BuildContext context) {
    print(isplaying);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
            Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (details){
                  if(direction!='up' && details.delta.dy>0)
                    direction='down';
                  else if(direction!='down' && details.delta.dy<0)
                    direction='up';
                },
                onHorizontalDragUpdate: (details)
                {
                  if(direction!='left' && details.delta.dx>0)
                    direction='right';
                  else if(direction!='right' && details.delta.dx<0)
                    direction='left';
                },

                child: AspectRatio(
                  aspectRatio: (squareperrow)/(squarepercol+3),
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: squareperrow,
                      ),
                      itemCount: squareperrow*squarepercol,
                      itemBuilder:(BuildContext context,int index)
                      {
                        var color;
                        var x=index%squareperrow;
                        var y=(index/squareperrow).floor();
                        bool issnakebody=false;
                        for(var ele in snake)
                          {
                            if(ele[0]==x && ele[1]==y)
                              {
                                issnakebody=true;
                                break;
                              }
                          }
                       /// green is head
                        /// yellow is body
                        /// red is food particle
                        if(snake[0][0]==x && snake[0][1]==y)
                          color=Colors.green;
                        else if(issnakebody)
                          color=Colors.green[200];
                        else if(food[0]==x && food[1]==y)
                          color=Colors.red;
                        else
                          color=Colors.grey[800];



                        return Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(shape: BoxShape.circle,color:color),);}
                  )),),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  color: isplaying ? Colors.red : Colors.blue,
                  child: Text(
                    isplaying? "End": "Start",
                    style: (fontstyle),
                  ),
                  onPressed: (){
                   if(isplaying)
                      isplaying=false;
                    else
                      {
                      startgame();
                      }

                  },
                ),
                Text(
                  "Score: ${snake.length-2}",
                   style:TextStyle(color: Colors.white,fontSize: 20)
                )

              ],
            ),
          ),
        ],

      ),

    );
  }
}
