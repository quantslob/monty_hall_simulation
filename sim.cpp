


#include <iostream>
#include <vector>
#include <stdlib.h>

/// g++ -o sim sim.cpp
/// ./sim


int main() {
    
    int n = 3 ; // number of doors
    int r = 1 ; // number of losing doors revealed by host, must be > 0 AND < n - 1
    int nn = 10000000 ; // total number of simulations
    
    int d_space[n] ;
    
    int door_prize ;
    int door_select ;
    
    int xndx_p, xndx_s ;
    
    int doors_can_reveal[ n - 1 ] ;
    int doors_revealed[ r ] ;
    int doors_can_switch_to[ n - r - 1 ] ;
    
    int doors_not_available_for_switch[ r + 1 ] ;
    
    //int xndx_cr ;
    
    int xcan_use ;
    
    int door_switch ;
    
    int i, j, jj, kk ;
    
    int bigSum_os = 0 ;
    int bigSum_sw = 0 ;
    
    double prop_sw, prop_os ;
    
    for(i=0; i<n; i++) {
        d_space[i] = i + 1 ;
    }
    
    for(i=0; i<nn; i++) {
        
        xndx_p = rand() % n ;
        xndx_s = rand() % n ;
        
        door_prize = d_space[ xndx_p ] ;
        door_select = d_space[ xndx_s ] ;
        
        kk = 0 ;
        for(j=0; j<n; j++) {
            if( (d_space[j] != door_prize) && (d_space[j] != door_select) ) {
                doors_can_reveal[kk] = d_space[ j ] ;
                kk = kk + 1 ;
            }
        }
        
        //// deterministic -- just first available
        for(j=0; j<r; j++) {
            doors_revealed[j] = doors_can_reveal[j] ;
        }
    
        
        doors_not_available_for_switch[0] = door_select ;
        for(jj=0; jj<r; jj++) {
            doors_not_available_for_switch[jj+1] = doors_revealed[jj] ;
        }
        
        for(j=0; j<n; j++) {
            xcan_use = 1 ;
            for(jj=0; jj<r+1; jj++) {
                if( d_space[ j ] == doors_not_available_for_switch[jj] ) {
                    xcan_use = 0 ;
                }
            }
            
            if(xcan_use == 1) { ////// deterministic -- first available
                door_switch = d_space[ j ] ;
                goto stop ;
            }
        }
        
    stop:
        
        if(door_prize == door_select) {
            bigSum_os = bigSum_os + 1 ;
        }
        
        if(door_prize == door_switch) {
            bigSum_sw = bigSum_sw + 1 ;
        }
          
        //std::cout << door_select << "\t" << door_prize << "\t" << doors_revealed[0] << "\t" << doors_can_switch_to[0] << "\n";
        
    }
    
    prop_os = static_cast<double>(bigSum_os) / nn ;
    prop_sw = static_cast<double>(bigSum_sw) / nn ;
    
   
    std::cout << "Total wins original selection: " << bigSum_os << "\n" << "Total wins switch: " << bigSum_sw << "\n" ;
    
    std::cout.precision(7) ;
    std::cout << "Proportion wins original selection: " << std::fixed << prop_os << "\n" << "Proportion wins switch: " << prop_sw << "\n" ;
    
    return 0 ;
}


