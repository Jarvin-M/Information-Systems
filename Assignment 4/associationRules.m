% Course: Information Systems
% Association Rule Analysis with Apriori
% Author: Dr. George Azzopardi
% Date: December 2019

% input parameters: minsup = minimum support, minconf = minimum confidence,
% antimonotone = true(to use the property)/ false(ignore the property)
function rules = associationRules(minsup,minconf, antimonotone)
    shoppingList = readDataFile;

    ntrans = size(shoppingList,1);
    items = unique([shoppingList{:}]);
    nitems = numel(items);

    [tridx,trlbl] = grp2idx(items);

    % Create the binary matrix
    dataset = zeros(ntrans,nitems);
    for i = 1:ntrans
       dataset(i,tridx(ismember(items,shoppingList{i}))) = 1;
    end

    % Generate frequent items of length 1
    support{1} = sum(dataset)/ntrans;
    f = find(support{1} >= minsup);
    frequentItems{1} = tridx(f);
    support{1} = support{1}(f);
    % Generate frequent item sets
    k = 1;
    while k < nitems && size(frequentItems{k},1) > 1
        % Generate length (k+1) candidate itemsets from length k frequent itemsets
        frequentItems{k+1} = [];
        support{k+1} = [];

        % Consider joining possible pairs of item sets
        for i = 1:size(frequentItems{k},1)-1
            for j = i+1:size(frequentItems{k},1)
                if k == 1 || isequal(frequentItems{k}(i,1:end-1),frequentItems{k}(j,1:end-1))
                    candidateFrequentItem = union(frequentItems{k}(i,:),frequentItems{k}(j,:));  
                    if all(ismember(nchoosek(candidateFrequentItem,k),frequentItems{k},'rows'))                
                        sup = sum(all(dataset(:,candidateFrequentItem),2))/ntrans;                    
                        if sup >= minsup
                            frequentItems{k+1}(end+1,:) = candidateFrequentItem;
                            support{k+1}(end+1) = sup;
                        end
                    end
                else
                    break;
                end            
            end
        end         
        k = k + 1;
    end


    rules = {}; % cell array of extracted rules
    ct = 1; % count of the rule generated
    for i =2:length(support)-1 % no association rules for the  first itemset
        Lset = frequentItems{i};
        for itemset=1:size(Lset,1)
            % specific frequent itemset
            whichset = Lset(itemset,:); 

            allcombin ={}; % all subsets in this itemset
            for j=1:(length(whichset)-1) % get combinations of size k-1
                allsets = nchoosek(whichset,j); %subsets S of whichset of size j
                for row=1:size(allsets,1)
                    allcombin{end+1,1} = allsets(row,:);
                end
            end

            allcombin = flip(allcombin);
            disantecedents = {}; % discarded antecedents for anitmonotone   
            %for every non empty subset s of x output the rule S => I-S

            for f=1:length(allcombin)
                if antimonotone
                    %anti-monotone
                    % If a rule S->(I ?S) does not satisfy the confidence threshold, 
                    % then any rule S?-> (I ? S?),where S? is a subset of S,
                    % must not satisfy the confidence threshold as well

                    %check if combination is a subset of any of the discarded
                    occur = cellfun(@ismember,repmat(allcombin(f), size(disantecedents)), disantecedents, 'UniformOutput',false);
                    found = any(cellfun(@all, occur)); % true or false if any of the combinations is a subset of the 

                    if found
                        %if allcombination is a subset, then skip to next iteration
                        continue
                    end
                end
                notsubset = setdiff(whichset, allcombin{f}); %I-S

                %extracting the support values
                whichsupcol = length(allcombin{f}); % cell index dependent on size of itemset
                indexincol = find(ismember(frequentItems{whichsupcol}, allcombin{f},'rows'));
                % conf(s => I-S)
                conf = support{i}(itemset)/support{whichsupcol}(indexincol);
                if antimonotone
                    if conf < minconf
                        disantecedents{end+1,1} = allcombin{f};
                    end
                end

                if conf >= minconf
                    rules{ct, 1} = allcombin{f};
                    rules{ct, 2} = notsubset;
                    rules{ct, 3} = conf;
                    ct = ct+1;
                end

            end


        end
    end

end

