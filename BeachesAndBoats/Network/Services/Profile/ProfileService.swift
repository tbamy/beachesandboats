//
//  ProfileService.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 16/10/2024.
//

import Foundation

protocol ProfileService{
    func BeachData(completion: @escaping(Result<BeachDataResponse, ErrorResponse>) -> Void)
}
