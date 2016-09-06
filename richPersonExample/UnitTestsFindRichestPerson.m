classdef UnitTestsFindRichestPerson < matlab.unittest.TestCase
    
    properties
        % oldPath
    end
    
    methods (Test)
        %% 
        function testTwoPersons1(testCase)
            % create input
            coinAmounts = [1 0 0 0; 0 0 0 1];
            
            % define expected output
            expOut = 1;
            actOut = findRichestPerson(coinAmounts);
            testCase.verifyTrue(expOut == actOut);
        end
        
        
        %% 
        function testTwoPersons2(testCase)
            % create input
            coinAmounts = [1 0 0 0; 1 0 0 0];
            
            % define expected output
            expOut = 1;
            actOut = findRichestPerson(coinAmounts);
            testCase.verifyTrue(expOut == actOut);
        end
        
        %% 
        function testWithMissingValues(testCase)
            % create input
            coinAmounts = [1 0 0 0; 1 NaN 0 0];
            
            % define expected output
            expOut = 1;
            actOut = findRichestPerson(coinAmounts);
            testCase.verifyTrue(expOut == actOut);
        end
        
    end
end