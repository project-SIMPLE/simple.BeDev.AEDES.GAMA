model GamaToUnityUDP_Multi1

global skills: [network] {
    // กำหนดขนาดพื้นที่เป็น 50x50
    geometry shape <- envelope(45.0 
    	
    ); 
  

	image_file map_image  <- image_file("../includes/T_map_1.png");


init {
    create map_agent number: 1 {
        location <- {22.5, 22.5, 0.0};
    }
}


}



species map_agent {
    aspect default {
        // 3. วาดรูปให้ขนาดเท่ากับ envelope (50x50)
        //draw map_image size: {1000.0, 1000.0};
        
        // วาดขอบสีแดงล้อมรอบ agent เพื่อเช็คตำแหน่ง
        //draw square(1000.0) color: #brown;
        //draw square(1000.0) color: #ffffff;
        draw square(42.0) color: rgb(117, 117, 117);
    }
}




experiment Main type: gui {
    output {
        display "test" {
            // ปรับขนาดหน้าจอแสดงผลให้พอดีกับข้อมูล
            species map_agent aspect: default;
   
     
           
        }
    }
}