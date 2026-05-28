model GamaToUnityUDP_Multi1

global skills: [network] {
	
	
	
	
	
	bool start_simulation <- false;
    float total_duration_ms <- 5 * 60 * 1000.0; 
    float remaining_ms <- 300000.0;
    float start_machine_time <- 0.0;
    bool is_timer_initialized <- false;
    string time_display <- "05:00";
    float progress_val <- 1.0;

    reflex update_timer {
        if (start_simulation) {
            if (!is_timer_initialized) {
                start_machine_time <- gama.machine_time;
                is_timer_initialized <- true;
            }
            float time_passed <- gama.machine_time - start_machine_time;
            float calculated_remaining <- remaining_ms - time_passed;
            
            if (calculated_remaining > 0) {
                progress_val <- calculated_remaining / total_duration_ms;
                int total_seconds_left <- int(calculated_remaining / 1000);
                
                // จัดรูปแบบตัวเลข 00:00
                int m <- total_seconds_left div 60;
                int s <- total_seconds_left mod 60;
                string ms <- (m < 10) ? "0" + string(m) : string(m);
                string ss <- (s < 10) ? "0" + string(s) : string(s);
                time_display <- ms + ":" + ss;
            } else {
                start_simulation <- false;
                progress_val <- 0.0;
                time_display <- "00:00";
            }
        } else if (is_timer_initialized) {
            remaining_ms <- remaining_ms - (gama.machine_time - start_machine_time);
            is_timer_initialized <- false;
        }
    }
	
	
	
	
	
    // กำหนดขนาดพื้นที่เป็น 50x50
    geometry shape <- envelope(45.0 
    	
    ); 
  

	image_file map_image  <- image_file("../includes/WhatsApp Image 2026-05-22 at 13.17.20.jpeg");


init {
    create map_agent number: 1 {
        location <- {22.5, 22.5, 0.0};
    }
}


}



species map_agent {
    aspect default {
        // 3. วาดรูปให้ขนาดเท่ากับ envelope (50x50)
        draw map_image size: {45.0, 45.0};
        
        // วาดขอบสีแดงล้อมรอบ agent เพื่อเช็คตำแหน่ง
        //draw square(1000.0) color: #brown;
        //draw square(1000.0) color: #ffffff;
        //draw square(42.0) color: rgb(117, 117, 117);
    }
}




experiment Main type: gui {
	parameter "SYSTEM STATUS" var: start_simulation labels: ["START", "STOP"];
    output {
        display "test" {
            // ปรับขนาดหน้าจอแสดงผลให้พอดีกับข้อมูล
            species map_agent aspect: default;
   
     
           
        }
        
        
        
        
        display "Futuristic Display" background: #black {
            graphics "HUD Layer" {
                // กำหนดพิกัดกึ่งกลางหน้าจอ
                point center_pt <- {22.5, 22.5};
                float ring_radius <- 20.0; 
                
                // 1. วาดวงแหวนพื้นหลัง (Static Ring)
                draw circle(ring_radius) at: center_pt color: #transparent border: #darkgray width: 2.0;
                
                // 2. คำนวณสีและมุมของวงแหวนตามเวลาที่เหลือ
                rgb active_color <- #cyan;
                if (progress_val < 0.2) { active_color <- #red; }
                
                float end_angle <- -90.0 + (360.0 * progress_val);
                
                // 3. วาดวงแหวนที่เคลื่อนที่ (Progress Arc)
                draw arc(ring_radius, -90.0, end_angle) at: center_pt color: #transparent border: active_color width: 6.0;

                // 4. วาดตัวเลขเวลา (Timer Text) - ใช้ anchor: #center เพื่อให้อยู่กลางวงกลมพอดี
                draw time_display at: center_pt color: active_color font: font("Arial", 100, #bold) anchor: #center;
                
                // 5. วาดสถานะ Active/Paused ด้านล่าง
                string status_txt <- "PAUSED";
                rgb status_col <- #gray;
                if (start_simulation) {
                    status_txt <- "ACTIVE";
                    status_col <- #green;
                }
                draw status_txt at: {22.5, 30} color: status_col font: font("Arial", 50, #bold) anchor: #center;
                
                // 6. วาดหัวข้อด้านบน
                draw "REAL-WORLD TIMER (5 MIN)" at: {22.5, 15} color: #white font: font("Arial", 10) anchor: #center;
            }
        }
        
        
        
    }
}