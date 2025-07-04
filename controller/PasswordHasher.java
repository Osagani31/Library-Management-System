/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author ASUSV
 */
public class PasswordHasher {

    public static String hashPassword(String password) {
        // TODO: Implement real hashing (e.g., BCrypt)
        return password;
    }
    
    public static boolean checkPassword(String password, String hash) {
        // TODO: Implement real hash check (e.g., BCrypt)
        return password.equals(hash);
    }
}
