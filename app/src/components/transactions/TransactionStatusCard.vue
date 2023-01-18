<template>
  <v-card flat>
    <v-card-text>
      <h6 class="text-body-1 font-weight-bold">Status</h6>
    </v-card-text>

    <v-divider />

    <v-card-text>
      <KVText
        title="Approvals"
        :value="`${transaction.approvers.length} out of ${safe.threshold}`"
      />
      <KVText title="Rejections" :value="transaction.rejecters.length" />

      <div class="d-flex align-center mt-5" v-if="transaction.status == 0">
        <v-btn
          flat
          class="w-auto me-2"
          color="success"
          @click="$emit('approve')"
          :disabled="transaction.isApprovedBy(address)"
        >
          Approve
        </v-btn>
        <v-spacer />
        <v-btn
          flat
          class="w-auto ms-2"
          color="error"
          @click="$emit('reject')"
          :disabled="transaction.isRejectedBy(address)"
        >
          Reject
        </v-btn>
      </div>
      <v-btn
        v-else-if="transaction.status == 1"
        flat
        block
        class="mt-5"
        color="primary"
        @click="$emit('execute')"
      >
        Execute
      </v-btn>

      <v-chip
        v-else-if="transaction.status == 2 || transaction.status == 3"
        flat
        label
        class="mt-5"
        variant="outlined"
        :color="transaction.status == 2 ? 'error' : 'success'"
      >
        <span class="text-center">
          {{ transaction.statusValue }}
        </span>
      </v-chip>
    </v-card-text>
  </v-card>
</template>

<script lang="ts" setup>
import { Safe, SafeTransaction } from "@/lib/entity";
import KVText from "@/components/text/KVText.vue";

defineProps<{ transaction: SafeTransaction; safe: Safe; address: string }>();
defineEmits(["approve", "reject", "execute"]);
</script>
