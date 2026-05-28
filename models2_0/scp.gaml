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
    geometry shape <- envelope(120.0);
    
//    string base_name <- "scp_data";
//    string extension <- ".csv";
//    string folder_path <- "../includes/SCP_CSV/";
//    string final_file_name; 
  

	image_file map_image  <- image_file("../includes/WhatsApp Image 2026-05-09 at 16.23.10.jpeg");


init {
    create map_agent number: 1 {
        location <- {78.7, -81.4, 0.0};
    }
    
    
    
//    int i <- 0;
//        string temp_name <- base_name + extension;
//        
//        // วนลูปตรวจสอบว่าไฟล์มีอยู่หรือไม่ ถ้ามีให้เพิ่มเลขต่อท้ายไปเรื่อยๆ
//        loop while: file_exists(folder_path + temp_name) {
//            i <- i + 1;
//            temp_name <- base_name + i + extension;
//            }
//            final_file_name <- temp_name;
//        write "บันทึกข้อมูลลงไฟล์: " + final_file_name;
    
    
}
//reflex save_data {
//        save ["Cycle: " + cycle, "Time: " + time] to: folder_path + final_file_name rewrite: false header: true;
//    }

}



species map_agent {
    aspect default {
        // 3. วาดรูปให้ขนาดเท่ากับ envelope (50x50)
        draw map_image size: {120.0, 120.0};
        
        // วาดขอบสีแดงล้อมรอบ agent เพื่อเช็คตำแหน่ง
        //draw square(1000.0) color: #brown;
        //draw square(1000.0) color: #ffffff;
        //draw square(120.0) color: rgb(117, 117, 117);
        // วาดชื่อกำกับเพื่อให้เห็นตำแหน่งชัดขึ้น
       // draw "Target" at: {78.7, -81.4 + 10} color: #black;
    
    }
}




experiment Main type: gui {
	 parameter "SYSTEM STATUS" var: start_simulation labels: ["START", "STOP"];
        
    
    output {
    	
        display "test" {
        	// วาดแกน XYZ เพื่อให้เห็นจุด {0,0} ชัดเจน
            // target: คือจุดที่กล้องมองไป (ให้ตรงกับพิกัด Agent ของคุณ)
            camera #default location: {78.7, -81.4, 200.0} target: {78.7, -81.4, 0.0};
            species map_agent aspect: default;
   
     
           
        }
        
        display "Futuristic Display" background: #black {
            graphics "HUD Layer" {
                // กำหนดพิกัดกึ่งกลางหน้าจอ
                point center_pt <- {60, 60};
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
                draw status_txt at: {60, 100} color: status_col font: font("Arial", 50, #bold) anchor: #center;
                
                // 6. วาดหัวข้อด้านบน
                draw "REAL-WORLD TIMER (5 MIN)" at: {60, 25} color: #white font: font("Arial", 10) anchor: #center;
            }
        }
    }
}



//experiment Main type: gui {
//    output {
//       display "test" {
//    // ปรับมุมมองกล้องให้กว้างขึ้น เพื่อให้เห็นทั้ง 0,0 และ 78.7, -81.4
//    camera #default location: {39.35, -40.7, 250.0} target: {39.35, -40.7, 0.0};
//    
//    // วาดเส้นแกน X (สีแดง) จาก -50 ถึง 150 ที่ระดับ Y=0
//    graphics "axis_x" {
//        draw line([{ -50.0, 0.0, 0.0}, {150.0, 0.0, 0.0}]) color: #red width: 2;
//    }
//    
//    // วาดเส้นแกน Y (สีเขียว) จาก -150 ถึง 50 ที่ระดับ X=0
//    graphics "axis_y" {
//        draw line([{0.0, -150.0, 0.0}, {0.0, 50.0, 0.0}]) color: #green width: 2;
//    }
//    
//    // วาดจุด Origin {0,0} ให้เด่นๆ
//    graphics "origin_point" {
//        draw circle(5.0) at: {0,0,0} color: #black;
//    }
//    
//    species map_agent aspect: default;
//}
//    }
//}