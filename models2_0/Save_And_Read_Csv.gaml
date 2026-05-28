//model NewModel1
//
//global {
//    file my_csv_data <- csv_file("../models/my_data.csv", ","); 
//    matrix data_matrix <- matrix(my_csv_data); // แปลงไฟล์เป็น Matrix
//
//    init {
//        // เขียนแสดงผลใน Console ของ GAMA
//        write "จำนวนแถว: " + data_matrix.rows;
//        write "จำนวนคอลัมน์: " + data_matrix.columns;
//        write "ข้อมูลในแถวที่ 0 คอลัมน์ที่ 0 คือ: " + data_matrix[0,0];
//        
//        // ถ้าอยากดูข้อมูลทั้งหมด
//        write "ข้อมูลทั้งหมดคือ: " + data_matrix;
//    }
//}
//
//
//
//
//experiment MyExperiment type: gui {
//    output {
//        // สร้างหน้าต่างแสดงผล
//        display "Data View" {
//            // คุณสามารถใส่กราฟหรือรูปภาพที่นี่
//        }
//
//        // ใช้ monitor เพื่อดูค่าของตัวแปร data_matrix
//        monitor "CSV Data Content" value: data_matrix refresh: every(1);
//    }
//}




//model NewModel1
//
//global {
//    reflex save_data {
//        // ตัด type: "csv" ออก เพราะ GAMA รู้จักจากชื่อไฟล์ .csv อยู่แล้ว
//        // เพิ่ม attribute: เพื่อบอกข้อมูลที่ต้องการบันทึก
//        save ["Cycle: " + cycle, "Time: " + time] to: "../includes/DataCSV/my_data.csv" rewrite: false header: true;
//    }
//}
//
//experiment MyExperiment type: gui {
//    output {
//        display "Main Display" { }
//    }
//}








model NewModel1

global {
    string base_name <- "my_data";
    string extension <- ".csv";
    string folder_path <- "../includes/DataCSV/";
    string final_file_name;

    init {
        int i <- 0;
        string temp_name <- base_name + extension;
        
        // วนลูปตรวจสอบว่าไฟล์มีอยู่หรือไม่ ถ้ามีให้เพิ่มเลขต่อท้ายไปเรื่อยๆ
        loop while: file_exists(folder_path + temp_name) {
            i <- i + 1;
            temp_name <- base_name + i + extension;
        }
        
        final_file_name <- temp_name;
        write "บันทึกข้อมูลลงไฟล์: " + final_file_name;
    }

    reflex save_data {
        save ["Cycle: " + cycle, "Time: " + time] to: folder_path + final_file_name rewrite: false header: true;
    }
}

experiment MyExperiment type: gui {
    output {
        display "Main Display" { }
    }
}