//
//  Untitled.swift
//  StudyFit
//

import Foundation

class UserDefaultsManager{
    private static let testResultsKey = "saved_test_results"
    private static let lastResultKey = "last_test_result"
    
    // MARK: - 테스트 결과 저장
    static func saveTestResults(_ result: StudyResult){
        print("💾 테스트 결과 저장 중...")
        
        // 1. 새 결과를 마지막 결과로 저장
        saveLastResult(result)
        
        // 2. 전체 결과 목록에 추가
        var allResults = getAllTestResults()
        allResults.append(result)
        
        // 최대 10개까지만 저장 (용량 관리)
        if allResults.count > 10{
            allResults = Array(allResults.suffix(10))
        }
        
        // 3. UserDefaults에 저장
        do{
            let data = try JSONEncoder().encode(allResults)
            UserDefaults.standard.set(data, forKey: testResultsKey)
            print("테스트 결과 저장 완료! (총 \(allResults.count)개)")
        }catch{
            print("테스트 결과 저장 실패: \(error)")
        }
    }
    
    // MARK: - 마지막 결과 저장/불러오기
    private static func saveLastResult(_ result: StudyResult){
        do{
            let data = try JSONEncoder().encode(result)
            UserDefaults.standard.set(data, forKey: lastResultKey)
            print("최근 결과 저장 완료! (총\(result.personalityType.displayName)")
        }catch{
            print("최근 결과 저장 실패: \(error)")
        }
    }

    static func getLastTestResult() -> StudyResult?{
        guard let data = UserDefaults.standard.data(forKey: lastResultKey) else{
            print("저장된 최근 결과가 없습니다")
            return nil
        }
        
        do{
            let result = try JSONDecoder().decode(StudyResult.self, from: data)
            print("최근 결과 불러오기 성공: \(result.personalityType.displayName)")
            return result
        }catch{
            print("최근 결과 불러오기 실패: \(error)")
            return nil
        }
        
    }

    // MARK: - 전체 결과 불러오기
    static func getAllTestResults() -> [StudyResult]{
        guard let data = UserDefaults.standard.data(forKey: testResultsKey) else{
            print("저장된 결과 목록이 없습니다")
            return []
        }
        
        do{
            let results = try JSONDecoder().decode([StudyResult].self, from: data)
            let sortedResults = results.sorted { $0.timestamp > $1.timestamp } // 최신순
            print("결과 목록 불러오기 성공: \(sortedResults.count)개")
            return sortedResults
        }catch{
            print("결과 목록 불러오기 실패: \(error)")
            return []
        }
    }

    // MARK: - 통계 정보
    static func getTestCount() -> Int{
        return getAllTestResults( ).count
    }

    static func getMostFrequentPersonalityType() -> StudyPersonalityType?{
        let results = getAllTestResults()
        guard !results.isEmpty else{
            return nil
        }
        
        let typeCount = results.reduce(into: [StudyPersonalityType: Int]()) { counts, result in
            counts[result.personalityType, default: 0] += 1
        }
        
        return typeCount.max(by: { $0.value < $1.value })?.key
    }

    // MARK: - 데이터 관리
    static func clearAllResults(){
        UserDefaults.standard.removeObject(forKey: testResultsKey)
        UserDefaults.standard.removeObject(forKey: lastResultKey)
        print("모든 테스트 결과 삭제 완료!")
    }
}

